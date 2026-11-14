#!/usr/bin/env python3
"""Give hyprpm exact installed/running sources without release-branch history.

hyprpm 0.56 shallow-clones only branch=main. Its supported --hl-url accepts
this local cache; hyprpm still installs/validates headers and selects plugin
commit pins. All Git settings below are scoped to that child, never global.
"""
import json
import os
from pathlib import Path
import re
import subprocess
import sys

UPSTREAM = "https://github.com/hyprwm/Hyprland"


def git(root, *args, capture=False):
    result = subprocess.run(["git", "-C", str(root), *args], check=True,
                            text=True, stdout=subprocess.PIPE if capture else None)
    return result.stdout.strip() if capture else None


def prepare(root, commit, upstream=UPSTREAM):
    """Fetch only the requested commit and pinned submodule snapshots; reuse them."""
    if not re.fullmatch(r"[0-9a-fA-F]{40}", commit):
        raise ValueError("Hyprland did not report a full Git commit")
    root = Path(root) / commit.lower()
    root.mkdir(parents=True, exist_ok=True)
    if not (root / ".git").exists():
        git(root, "init", "--quiet")
        git(root, "remote", "add", "origin", upstream)
    # A failed transfer can be retried in the same repo. Never silently replace
    # the requested revision with HEAD/a tag or deepen to full history.
    exists = subprocess.run(["git", "-C", str(root), "cat-file", "-e", commit + "^{commit}"],
                            stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL).returncode == 0
    if not exists:
        print(f"Downloading Hyprland {commit[:12]} (one commit, not full history)", flush=True)
        git(root, "fetch", "--depth=1", "--no-tags", "--progress", "origin", commit)
    git(root, "checkout", "--quiet", "--detach", commit)
    if git(root, "rev-parse", "HEAD", capture=True).lower() != commit.lower():
        raise ValueError("Downloaded Hyprland revision does not match")
    print("Preparing pinned submodules (shallow, with Git transfer progress)", flush=True)
    git(root, "submodule", "update", "--init", "--recursive", "--depth=1", "--progress")
    return root


def local_submodules(root, environment):
    """Let hyprpm recursively clone prepared modules locally, not from GitHub."""
    environment = environment.copy()
    count = int(environment.get("GIT_CONFIG_COUNT", "0"))

    def setting(key, value):
        nonlocal count
        environment[f"GIT_CONFIG_KEY_{count}"] = key
        environment[f"GIT_CONFIG_VALUE_{count}"] = value
        count += 1

    # Git blocks file submodules by default. Only this build child gets file
    # transport; mappings come from the exact upstream commit's .gitmodules.
    setting("protocol.file.allow", "always")
    modules = [root]
    for module in modules:
        manifest = module / ".gitmodules"
        if not manifest.exists():
            continue
        entries = git(module, "config", "--file", str(manifest), "--get-regexp",
                      r"^submodule\..*\.url$", capture=True)
        for entry in entries.splitlines():
            key, url = entry.split(maxsplit=1)
            path_key = key[:-3] + "path"
            relative = git(module, "config", "--file", str(manifest), "--get", path_key, capture=True)
            child = (module / relative).resolve()
            if not child.is_relative_to(root.resolve()):
                raise ValueError("Submodule path escapes the source cache")
            repo = Path(git(child, "rev-parse", "--absolute-git-dir", capture=True))
            setting(f"url.{repo.as_uri()}.insteadOf", url)
            modules.append(child)
    environment["GIT_CONFIG_COUNT"] = str(count)
    return environment


def main():
    installed = json.loads(subprocess.check_output(["Hyprland", "--version-json"], text=True))
    running = json.loads(subprocess.check_output(["hyprctl", "-j", "version"], text=True))
    if (installed["commit"], installed["abiHash"]) != (running["commit"], running["abiHash"]):
        raise ValueError("Installed Hyprland differs from the running session; log out/in before building plugins")
    cache = Path(os.environ.get("XDG_CACHE_HOME") or Path.home() / ".cache") / "eclipse/hyprland-sources"
    root = prepare(cache, installed["commit"])
    environment = local_submodules(root, os.environ)
    print("Sources ready. hyprpm now configures matching headers/builds plugins; verbose output follows each stage.", flush=True)
    return subprocess.run(["hyprpm", "--hl-url", root.as_uri(), "--verbose", *sys.argv[1:]],
                          env=environment).returncode


if __name__ == "__main__":
    try:
        sys.exit(main())
    except (OSError, ValueError, KeyError, subprocess.SubprocessError) as error:
        sys.exit(f"Plugin source preparation failed: {error}")
