#!/usr/bin/env python3
"""Install the verified Eclipse-supported OMP release, never provider accounts.

Build-service protocol follows upstream's MIT-licensed installer:
https://github.com/can1357/oh-my-pi/blob/v18.12.6/scripts/install.sh
This independent implementation downloads data, never executes fetched scripts.
"""
import argparse
import hashlib
import json
import os
import platform
import re
import shutil
import subprocess
import sys
import tempfile
import time
import urllib.error
import urllib.request
from pathlib import Path

VERSION = "18.12.6"
BUILD_SERVICE = "https://build.stencil.so"


def install(install_dir=None, dry_run=False):
    """Preserve an installed OMP; atomically publish only a verified new binary."""
    directory = Path(install_dir).expanduser() if install_dir else Path.home() / ".local" / "bin"
    destination = directory / "omp"
    existing = shutil.which("omp") if install_dir is None else None
    if existing or os.path.lexists(destination):
        print(f"Keeping existing OMP: {existing or destination}")
        return
    architecture = {"x86_64": "x86_64", "amd64": "x86_64", "aarch64": "arm64", "arm64": "arm64"}.get(platform.machine().lower())
    if platform.system() != "Linux" or not architecture or platform.libc_ver()[0] != "glibc":
        raise RuntimeError("Eclipse's OMP installer supports glibc Linux x86_64/arm64; use upstream's installer for another platform")
    target = f"linux-{architecture}"
    endpoint = f"{BUILD_SERVICE}/api/products/omp/versions/{VERSION}/{target}"
    if dry_run:
        print(f"Would resolve pinned OMP {VERSION} ({target}) from {endpoint}, verify SHA-256 and --version, then create {destination}; no request made")
        return
    request = urllib.request.Request(endpoint, headers={"User-Agent": "Eclipse-OMP-installer"})
    with urllib.request.urlopen(request, timeout=30) as response:
        metadata = json.loads(response.read(1024 * 1024))
    build, artifact = metadata["build"], metadata["file"]
    digest = artifact["sha256"]
    url = metadata["download"]
    size = artifact["size"]
    if (build["product"] != "omp" or build["version"] != VERSION
            or artifact["platform"] != "linux" or artifact["arch"] != architecture
            or not isinstance(digest, str) or not re.fullmatch(r"[0-9a-f]{64}", digest)
            or not isinstance(url, str) or not url.startswith("https://")
            or not isinstance(size, int) or not 0 < size < 1024 * 1024 * 1024):
        raise RuntimeError("Build service returned unexpected release/target/checksum metadata")
    directory.mkdir(parents=True, exist_ok=True)
    descriptor, temporary_name = tempfile.mkstemp(prefix=".omp-download-", dir=directory)
    temporary = Path(temporary_name)
    try:
        actual_digest = hashlib.sha256()
        received = 0
        deadline = time.monotonic() + 600
        with os.fdopen(descriptor, "wb") as output:
            with urllib.request.urlopen(url, timeout=30) as response:
                while chunk := response.read(1024 * 1024):
                    received += len(chunk)
                    if received > size or time.monotonic() > deadline:
                        raise RuntimeError("OMP download exceeded expected size or deadline")
                    actual_digest.update(chunk)
                    output.write(chunk)
            output.flush()
            os.fsync(output.fileno())
        if received != size or actual_digest.hexdigest() != digest:
            raise RuntimeError("OMP download size or SHA-256 mismatch; nothing installed")
        temporary.chmod(0o755)
        # Even the paid-free version probe gets an empty HOME and no credentials.
        with tempfile.TemporaryDirectory(prefix="eclipse-omp-version-") as probe_home:
            result = subprocess.run([str(temporary.resolve()), "--version"],
                                    env={"HOME": probe_home, "PATH": os.defpath, "LANG": "C.UTF-8"},
                                    cwd=probe_home, capture_output=True, text=True, timeout=30, check=True)
        if result.stdout.strip() != f"omp/{VERSION}":
            raise RuntimeError("Downloaded OMP did not report the pinned version; nothing installed")
        # Same-filesystem link publishes the complete executable atomically and
        # refuses a concurrently created destination instead of overwriting it.
        os.link(temporary, destination)
        print(f"Installed OMP {VERSION} at {destination} (verified SHA-256 and --version)")
    finally:
        temporary.unlink(missing_ok=True)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--install-dir", help="Explicit target directory (default: ~/.local/bin); existing targets are always preserved")
    parser.add_argument("--dry-run", action="store_true", help="Describe only; no network requests or filesystem changes")
    arguments = parser.parse_args()
    try:
        install(arguments.install_dir, arguments.dry_run)
    except (OSError, ValueError, KeyError, TypeError, RuntimeError, subprocess.SubprocessError) as error:
        # Do not echo presigned build download URLs or inherited environment.
        detail = str(error) if isinstance(error, RuntimeError) else type(error).__name__
        print(f"OMP installation failed: {detail}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
