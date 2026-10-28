#!/usr/bin/env python3
"""Explicit Sine manual setup using upstream release archives, never a profile reset.

Usage: python3 app_integrations.py sine PROFILE_DIRECTORY BROWSER_INSTALL_DIRECTORY
Paths come from Zen's about:support, not a guessed default profile or executable wrapper.
Official procedure: https://github.com/sineorg/docs/blob/main/src/installation.md
"""
import hashlib
import io
import os
import re
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import time
from urllib.request import urlopen
import zipfile

# Compatible published upstream releases; update these together after upstream review.
ASSETS = (
    ("https://github.com/sineorg/bootloader/releases/download/v0.1.4/program.zip",
     "55cc14ebd141a32d746cfe93fc8ad9856eb0d553cc3727d3e408617e73d4ac4d", "program"),
    ("https://github.com/sineorg/bootloader/releases/download/v0.1.4/profile.zip",
     "285b3d589cc979f11f01c9c77410b717694ccc4f32cc1cb08bd6d8909fb98e00", "profile"),
    ("https://github.com/CosmoCreeper/Sine/releases/download/v2.3.3/engine.zip",
     "c98be8e0234e8c4d5b41dc277bd201a365a2dcc418dcba82d4749d27a64a3d65", "profile"),
)


def install_file_manager():
    """Activate Strata's upstream FileManager1 template without competing providers."""
    data = Path(os.environ.get("XDG_DATA_HOME") or Path.home() / ".local/share")
    state = Path(os.environ.get("XDG_STATE_HOME") or Path.home() / ".local/state")
    services = data / "dbus-1/services"
    source = Path("/usr/share/dbus-1/services/io.github.lgse.Strata.FileManager1.service")
    if not source.is_file():
        raise ValueError("Strata package lacks its FileManager1 service template")
    destination = services / source.name
    services.mkdir(parents=True, exist_ok=True)
    backup = state / "quickshell/app-backups" / ("filemanager-" + str(time.time_ns()))
    for service in services.glob("*.service"):
        if "Name=org.freedesktop.FileManager1" in service.read_text():
            if service == destination and service.read_bytes() == source.read_bytes():
                continue
            backup.mkdir(parents=True, exist_ok=True)
            shutil.move(str(service), backup / service.name)
    shutil.copy2(source, destination)
    subprocess.run(["gdbus", "call", "--session", "--dest", "org.freedesktop.DBus",
                    "--object-path", "/org/freedesktop/DBus", "--method",
                    "org.freedesktop.DBus.ReloadConfig"], check=True)
    print("Strata FileManager1 enabled; close any previously running file manager before testing.")
    if backup.exists():
        print("Previous per-user service providers preserved:", backup)


def install_sine(profile, program):
    profile, program = Path(profile).expanduser().resolve(), Path(program).expanduser().resolve()
    if not profile.is_dir() or not (profile / "prefs.js").is_file():
        raise ValueError("Choose the existing Profile Directory shown in Zen about:support")
    if not program.is_dir() or not (program / "application.ini").is_file():
        raise ValueError("Choose Zen's installation directory containing application.ini")
    if "zen" not in (program / "application.ini").read_text().lower():
        raise ValueError("The selected browser installation is not Zen")
    if subprocess.run(["pgrep", "-f", r"(^|/)(zen|zen-bin|zen-browser)( |$)"], capture_output=True).returncode == 0:
        raise ValueError("Close all Zen windows/processes before installing Sine")
    chrome = profile / "chrome"
    if chrome.is_symlink() or (profile / "user.js").is_symlink():
        raise ValueError("Refusing redirected profile chrome/user.js; use regular profile-owned paths")
    state = Path(os.environ.get("XDG_STATE_HOME") or Path.home() / ".local/state") / "quickshell"
    backup = state / "app-backups" / ("sine-" + str(time.time_ns()))
    backup.mkdir(parents=True)
    # Fetch and validate everything before changing the selected profile/program.
    with tempfile.TemporaryDirectory(prefix="eclipse-sine-") as work:
        staged = []
        for url, digest, target in ASSETS:
            with urlopen(url, timeout=60) as response:
                data = response.read(16 * 1024 * 1024)
            if hashlib.sha256(data).hexdigest() != digest:
                raise ValueError("Sine release checksum mismatch: " + url)
            with zipfile.ZipFile(io.BytesIO(data)) as archive:
                for member in archive.infolist():
                    relative = Path(member.filename)
                    if relative.is_absolute() or ".." in relative.parts or member.is_dir():
                        if member.is_dir():
                            continue
                        raise ValueError("Unsafe upstream archive path")
                    if member.file_size > 8 * 1024 * 1024 or (member.external_attr >> 16) & 0o170000 == 0o120000:
                        raise ValueError("Unsupported upstream archive member")
                    root = program if target == "program" else chrome
                    destination = root / relative
                    if not destination.resolve().is_relative_to(root.resolve()) or any(
                            part.is_symlink() for part in (destination, *destination.parents)
                            if part != root and part.is_relative_to(root)):
                        raise ValueError("Refusing redirected archive destination: " + str(destination))
                    source = Path(work) / target / relative
                    source.parent.mkdir(parents=True, exist_ok=True)
                    source.write_bytes(archive.read(member))
                    staged.append((source, destination, target, relative))
        if chrome.exists():
            shutil.copytree(chrome, backup / "chrome", symlinks=True)
        for source, destination, target, relative in staged:
            if target == "program":
                if destination.exists():
                    saved = backup / "program" / relative
                    saved.parent.mkdir(parents=True, exist_ok=True)
                    shutil.copy2(destination, saved)
                command = ["install", "-Dm644", str(source), str(destination)]
                if not os.access(program, os.W_OK):
                    command.insert(0, "sudo")
                subprocess.run(command, check=True)
            else:
                destination.parent.mkdir(parents=True, exist_ok=True)
                shutil.copy2(source, destination)
        # Firefox's supported stylesheet preference is merged without replacing
        # user.js, prefs.js, profiles.ini or any Sine/user mod configuration.
        prefs = profile / "user.js"
        old = prefs.read_text() if prefs.exists() else ""
        if prefs.exists():
            shutil.copy2(prefs, backup / "user.js")
        wanted = 'user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);'
        portal = 'user_pref("widget.use-xdg-desktop-portal.file-picker", 1);'
        begin, end = "// BEGIN Eclipse palette", "// END Eclipse palette"
        old = re.sub(re.escape(begin) + r".*?" + re.escape(end) + r"\n?", "", old, flags=re.S)
        prefs.write_text(old.rstrip() + "\n" + begin + "\n" + wanted + "\n" + portal + "\n" + end + "\n")
        (state / "zen-profile").write_text(str(profile) + "\n")
    print("Sine 2.3.3 + bootloader 0.1.4 installed into the selected Zen profile.")
    print("Backup:", backup)
    print("Open Zen about:support > Clear Startup Cache, fully restart, then confirm Sine in Settings.")
    print("Browser package updates can replace bootloader program files; rerun setup sine if Sine disappears.")


def main():
    if len(sys.argv) == 2 and sys.argv[1] == "file-manager":
        install_file_manager()
    elif len(sys.argv) == 4 and sys.argv[1] == "sine":
        install_sine(sys.argv[2], sys.argv[3])
    else:
        raise ValueError("Usage: app_integrations.py file-manager | sine PROFILE_DIRECTORY BROWSER_INSTALL_DIRECTORY")


if __name__ == "__main__":
    try:
        main()
    except (OSError, ValueError, subprocess.SubprocessError, zipfile.BadZipFile) as error:
        sys.exit(str(error))
