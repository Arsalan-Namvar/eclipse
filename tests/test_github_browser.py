"""Behavioral boundaries for the read-only GitHub browser."""
import importlib.util
import pathlib
import unittest
from unittest.mock import patch

SCRIPT = pathlib.Path(__file__).parents[1] / "home/.config/quickshell/scripts/github_browser.py"
spec = importlib.util.spec_from_file_location("github_browser", SCRIPT)
github = importlib.util.module_from_spec(spec)
spec.loader.exec_module(github)


class GitHubLists(unittest.TestCase):
    def browse(self, kind, rows, **kwargs):
        def reply(endpoint):
            return ({"login": "sample"}, False) if endpoint == "user" else (rows, True)
        with patch.object(github, "api", side_effect=reply):
            return github.browse(kind, owner="example", repo="project", **kwargs)

    def test_issue_list_excludes_prs_without_losing_pagination(self):
        result = self.browse("issues", [
            {"id": 1, "title": "PR in issues endpoint", "pull_request": {}, "number": 10},
            {"id": 2, "title": "Real issue", "number": 11,
             "html_url": "https://github.com/example/project/issues/11"},
        ])
        self.assertEqual([item["number"] for item in result["items"]], [11])
        self.assertTrue(result["next"])

    def test_closed_and_merged_pull_requests_are_distinct(self):
        rows = [
            {"id": 1, "title": "Merged", "number": 1, "state": "closed", "merged_at": "2026-01-01"},
            {"id": 2, "title": "Not merged", "number": 2, "state": "closed", "merged_at": None},
        ]
        self.assertEqual([r["number"] for r in self.browse("pulls", rows, state="merged")["items"]], [1])
        self.assertEqual([r["number"] for r in self.browse("pulls", rows, state="closed")["items"]], [2])
        self.assertEqual([r["number"] for r in self.browse("pulls", rows, state="all")["items"]], [1, 2])

    def test_empty_filtered_page_still_has_next(self):
        result = self.browse("repositories", [{"id": 1, "full_name": "example/other"}], query="wanted")
        self.assertEqual(result["items"], [])
        self.assertTrue(result["next"])
        self.assertEqual(result["filterScope"], "page")

    def test_private_repository_visibility_is_preserved(self):
        result = self.browse("repositories", [{"id": 7, "name": "secret", "full_name": "example/secret",
            "owner": {"login": "example"}, "private": True,
            "html_url": "https://github.com/example/secret"}])
        self.assertTrue(result["items"][0]["private"])
        self.assertEqual(result["items"][0]["owner"], "example")

    def test_external_links_cannot_open_other_origins(self):
        for url in ["javascript:alert(1)", "https://github.com.evil.test/x", "https://evil.test/", "https://github.com@evil.test/x"]:
            self.assertEqual(github.safe_url(url), "")
        self.assertEqual(github.safe_url("https://github.com/example/project/issues/1"), "https://github.com/example/project/issues/1")

    def test_invalid_repository_path_is_rejected(self):
        with patch.object(github, "api", return_value=({"login": "sample"}, False)):
            with self.assertRaises(ValueError):
                github.browse("issues", owner="example", repo="../../user")


if __name__ == "__main__":
    unittest.main()
