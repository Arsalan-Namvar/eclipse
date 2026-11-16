#!/usr/bin/env python3
"""Register the deployed Eclipse package through OMP's local plugin API."""
import argparse
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys


def register(dry_run=False):
    executable = shutil.which("omp")
    local = Path.home() / ".local/bin/omp"
    if not executable and os.access(local, os.X_OK):
        executable = str(local)
    if not executable:
        print("OMP integration waits until OMP is installed")
        return
    package = Path.home() / ".omp/agent/extensions/eclipse"
    if not (package / "package.json").is_file():
        raise RuntimeError("Eclipse OMP package is missing; deploy home files with setup sync first")
    result = subprocess.run([executable, "plugin", "list", "--json"],
                            check=True, capture_output=True, text=True)
    plugins = json.loads(result.stdout)
    for plugin in plugins.get("npm", []):
        if plugin.get("name") != "eclipse-desktop":
            continue
        if Path(plugin["path"]).resolve() != package.resolve():
            raise RuntimeError("Another eclipse-desktop plugin is installed; refusing to replace it")
        # Keep user enablement/features; repeated setup must not re-enable it.
        print("Keeping registered Eclipse OMP package")
        return
    if dry_run:
        print(f"Would register local OMP package: {package}; no provider configuration changes")
        return
    subprocess.run([executable, "plugin", "link", str(package)], check=True)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--dry-run", action="store_true")
    args = parser.parse_args()
    try:
        register(args.dry_run)
    except (OSError, ValueError, RuntimeError, subprocess.SubprocessError) as error:
        print(f"OMP integration: {error}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
