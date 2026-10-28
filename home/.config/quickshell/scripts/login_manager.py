#!/usr/bin/env python3
"""Explicit next-boot display-manager switch, with enabled-state rollback.

Never starts/stops a service. Discovery includes instantiated Ly services and
both loaded and installed managers; install does not call this cutover.
"""
import argparse
import json
import os
from pathlib import Path
import re
import shlex
import subprocess
import sys
import time

MANAGERS = re.compile(r"^(?:ly|sddm|gdm|lightdm|lxdm|greetd|xdm|slim|entrance)(?:@[^.]*)?\.service$")
STATE = Path(os.environ.get("XDG_STATE_HOME") or Path.home() / ".local/state") / "impasto/login"


def query(*args):
    return subprocess.run(["systemctl", *args], check=True, capture_output=True, text=True).stdout


def discover():
    installed = json.loads(query("list-unit-files", "--type=service", "--output=json", "--no-pager"))
    loaded = json.loads(query("list-units", "--type=service", "--all", "--output=json", "--no-pager"))
    names = {row["unit_file"] for row in installed if MANAGERS.fullmatch(row["unit_file"])}
    names.update(row["unit"] for row in loaded if MANAGERS.fullmatch(row["unit"]))
    # Include an arbitrary manager provided through the standard alias too.
    for root in (Path("/etc/systemd/system"), Path("/run/systemd/system")):
        alias = root / "display-manager.service"
        if alias.is_symlink():
            names.add(alias.resolve().name)
    names.add("sddm.service")
    result = {}
    for name in sorted(names):
        if name.endswith("@.service"):
            continue
        properties = dict(line.split("=", 1) for line in query(
            "show", name, "--property=Id,LoadState,ActiveState,UnitFileState").splitlines() if "=" in line)
        if properties.get("LoadState") == "not-found":
            if name == "sddm.service":
                raise ValueError("sddm.service is missing; install the sddm package first")
            continue
        canonical = properties.get("Id", name)
        result[canonical] = {"enabled": properties.get("UnitFileState", ""),
                             "active": properties.get("ActiveState", "unknown")}
    return result


def mutate(args, dry):
    command = (["sudo"] if os.geteuid() else []) + ["systemctl", *args]
    print("  " + shlex.join(command), flush=True)
    if not dry:
        subprocess.run(command, check=True)


def restore(snapshot, dry):
    units = snapshot["units"]
    # Disable only units touched by this transaction, then reconstruct their
    # prior persistent/runtime enablement. Active sessions remain untouched.
    for name in snapshot["changed"]:
        mutate(["disable", name], dry)
        mutate(["--runtime", "disable", name], dry)
    for name in snapshot["changed"]:
        enabled = units[name]["enabled"]
        if enabled == "enabled":
            mutate(["enable", name], dry)
        elif enabled == "enabled-runtime":
            mutate(["--runtime", "enable", name], dry)


def confirm(yes, dry):
    print("No service will be started/stopped. Changes take effect at next boot.")
    if not yes and not dry:
        if not sys.stdin.isatty() or input("Apply this next-boot login change? [y/N] ").lower() not in ("y", "yes"):
            raise ValueError("Login change cancelled")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--dry-run", action="store_true")
    parser.add_argument("--yes", action="store_true")
    parser.add_argument("--restore", action="store_true")
    args = parser.parse_args()
    if args.restore:
        snapshot = json.loads((STATE / "latest.json").read_text())
        print("Restore previous enabled state:")
        for name in snapshot["changed"]:
            print(f"  {name}: {snapshot['units'][name]['enabled']}")
        confirm(args.yes, args.dry_run)
        restore(snapshot, args.dry_run)
        return
    units = discover()
    print("Detected display managers (enabled state; current active state):")
    for name, values in units.items():
        print(f"  {name}: {values['enabled']}; {values['active']}")
    if units["sddm.service"]["enabled"] in ("masked", "masked-runtime"):
        raise ValueError("SDDM is masked; review that deliberate mask before changing login managers")
    changed = [name for name, values in units.items()
               if name != "sddm.service" and (values["enabled"] in ("enabled", "enabled-runtime")
                                               or values["active"] in ("active", "activating"))]
    if not changed and units["sddm.service"]["enabled"] == "enabled":
        print("SDDM is already enabled with no competing enabled manager; preserving the previous rollback snapshot.")
        return
    print("Disable for next boot: " + (", ".join(changed) or "none"))
    print("Enable for next boot: sddm.service")
    confirm(args.yes, args.dry_run)
    snapshot = {"units": units, "changed": changed + ["sddm.service"]}
    if not args.dry_run:
        STATE.mkdir(parents=True, exist_ok=True)
        filename = STATE / (str(time.time_ns()) + ".json")
        filename.write_text(json.dumps(snapshot, indent=2) + "\n")
        (STATE / "latest.json").write_text(filename.read_text())
        print("Enabled-state backup:", filename)
    try:
        for name in changed:
            mutate(["disable", name], args.dry_run)
            if units[name]["enabled"] == "enabled-runtime":
                mutate(["--runtime", "disable", name], args.dry_run)
        mutate(["enable", "sddm.service"], args.dry_run)
    except subprocess.CalledProcessError:
        print("Login enablement failed; restoring previous enabled state.", file=sys.stderr)
        restore(snapshot, False)
        raise
    print("Next-boot SDDM configured. Reboot only when ready; current login/session was not stopped.")
    print("Rollback: ./setup login --restore (restores enablement, not theme files).")


if __name__ == "__main__":
    try:
        main()
    except (OSError, ValueError, KeyError, subprocess.SubprocessError) as error:
        sys.exit(str(error))
