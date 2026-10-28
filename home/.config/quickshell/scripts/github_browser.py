#!/usr/bin/env python3
"""Read-only GitHub navigator. Authentication stays in GitHub CLI's credential store.

Only fixed GET endpoints are accepted. Results stay in process memory, never a
private-content cache. Output includes pagination even when page-local filtering
leaves no rows; callers must not interpret an empty page as end-of-results.
"""
import argparse
import json
import re
import shutil
import subprocess
from urllib.parse import quote, urlencode, urlparse

PAGE_SIZE = 30
NAME = re.compile(r"[A-Za-z0-9_.-]+\Z")


class ApiError(Exception):
    def __init__(self, reason, message):
        super().__init__(message)
        self.reason = reason


def safe_url(value):
    parsed = urlparse(value or "")
    return value if parsed.scheme == "https" and parsed.netloc == "github.com" else ""


def api(endpoint):
    if not shutil.which("gh"):
        raise ApiError("setup", "Install GitHub CLI and sign in with gh auth login.")
    try:
        result = subprocess.run(
            ["gh", "api", "--hostname", "github.com", "--method", "GET", "--include",
             "-H", "Accept: application/vnd.github+json", endpoint],
            capture_output=True, text=True, timeout=35,
        )
    except subprocess.TimeoutExpired as error:
        raise ApiError("network", "GitHub request timed out.") from error
    # gh emits HTTP headers followed by one JSON document; never forward raw
    # stderr or response bodies which may contain private repository content.
    output = result.stdout.replace("\r\n", "\n")
    header, separator, body = output.partition("\n\n")
    status_match = re.search(r"^HTTP/\S+\s+(\d+)", header)
    status = int(status_match[1]) if status_match else 0
    headers = {}
    for line in header.splitlines()[1:]:
        key, colon, value = line.partition(":")
        if colon:
            headers[key.lower()] = value.strip()
    if result.returncode:
        if status == 401 or (not status and "gh auth login" in result.stderr):
            reason, message = "authentication", "Sign in to github.com using gh auth login."
        elif status == 429 or (status == 403 and (headers.get("x-ratelimit-remaining") == "0" or "retry-after" in headers)):
            reason, message = "rate", "GitHub rate limit reached. Try again later."
        elif status == 403:
            reason, message = "permission", "GitHub denied access. Check repository and organization/SSO permissions."
        elif status == 404:
            reason, message = "permission", "Repository not found or not accessible to the signed-in account."
        else:
            reason, message = "network", "GitHub could not be reached or returned an error."
        raise ApiError(reason, message)
    try:
        payload = json.loads(body if separator else output)
    except ValueError as error:
        raise ApiError("response", "GitHub returned an invalid response.") from error
    return payload, 'rel="next"' in headers.get("link", "")


def validated(value, label):
    if not NAME.fullmatch(value):
        raise ValueError("Invalid " + label)
    return quote(value, safe="")


def browse(kind, owner="", repo="", page=1, state="open", query=""):
    params = {"per_page": PAGE_SIZE, "page": page}
    if kind == "account":
        data, _ = api("user")
        return {"account": data.get("login", ""), "url": safe_url(data.get("html_url")), "items": [], "next": False}
    account_data, _ = api("user")
    account = account_data.get("login", "")
    if kind == "repositories":
        endpoint = "user/repos"
        params.update(affiliation="owner,collaborator,organization_member", sort="pushed", direction="desc")
    elif kind == "organizations":
        endpoint = "user/orgs"
    elif kind == "org-repositories":
        endpoint = "orgs/" + validated(owner, "organization") + "/repos"
        params.update(type="all", sort="pushed", direction="desc")
    elif kind in {"issues", "pulls"}:
        endpoint = "repos/" + validated(owner, "owner") + "/" + validated(repo, "repository") + "/" + kind
        params.update(state="closed" if state in {"closed", "merged"} else state, sort="updated", direction="desc")
    else:
        raise ValueError("Unknown view")
    data, has_next = api(endpoint + "?" + urlencode(params))
    if not isinstance(data, list):
        raise ApiError("response", "GitHub returned an unexpected list response.")
    items = []
    for row in data:
        if kind == "issues" and "pull_request" in row:
            continue
        if kind == "pulls" and state == "merged" and not row.get("merged_at"):
            continue
        if kind == "pulls" and state == "closed" and row.get("merged_at"):
            continue
        title = row.get("title") or row.get("full_name") or row.get("login", "")
        description = row.get("description") or ""
        if query.casefold() not in (title + " " + description).casefold():
            continue
        items.append({
            "id": row["id"], "title": title, "description": description,
            "url": safe_url(row.get("html_url")) or ("https://github.com/" + row["login"] if kind == "organizations" else ""),
            "name": row.get("name", ""), "owner": (row.get("owner") or {}).get("login", row.get("login", "")),
            "number": row.get("number", 0), "private": bool(row.get("private")),
            "state": "merged" if row.get("merged_at") else row.get("state", ""),
            "updated": row.get("updated_at", ""),
        })
    return {"account": account, "items": items, "next": has_next, "page": page, "filterScope": "page"}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("kind", choices=["account", "repositories", "organizations", "org-repositories", "issues", "pulls"])
    parser.add_argument("--owner", default="")
    parser.add_argument("--repo", default="")
    parser.add_argument("--page", type=int, default=1)
    parser.add_argument("--state", choices=["open", "closed", "merged", "all"], default="open")
    parser.add_argument("--query", default="")
    args = parser.parse_args()
    try:
        if args.page < 1:
            raise ValueError("Page must be positive")
        reply = browse(args.kind, args.owner, args.repo, args.page, args.state, args.query)
    except ApiError as error:
        reply = {"error": str(error), "reason": error.reason, "items": [], "next": False}
    except (ValueError, OSError, KeyError, TypeError):
        reply = {"error": "GitHub request or response could not be processed.", "reason": "response", "items": [], "next": False}
    print(json.dumps(reply))


if __name__ == "__main__":
    main()
