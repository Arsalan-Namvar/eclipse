#!/usr/bin/env python3
"""An explicit Bluetooth power-on clears software rfkill blocks first."""
import argparse
import json
import re
import subprocess
import sys


def set_power(adapter, enabled):
    if not re.fullmatch(r"/org/bluez/hci[0-9]+", adapter):
        raise ValueError("Invalid Bluetooth adapter path")
    if enabled:
        # Bluetooth only: never unblock Wi-Fi or override a hardware switch.
        subprocess.run(["rfkill", "unblock", "bluetooth"], check=True,
                       capture_output=True, text=True, timeout=5)
    subprocess.run(["busctl", "--system", "set-property", "org.bluez", adapter,
                    "org.bluez.Adapter1", "Powered", "b", "true" if enabled else "false"],
                   check=True, capture_output=True, text=True, timeout=15)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("adapter")
    parser.add_argument("power", choices=("on", "off"))
    args = parser.parse_args()
    try:
        set_power(args.adapter, args.power == "on")
    except (OSError, ValueError, subprocess.SubprocessError) as error:
        detail = error.stderr.strip() if isinstance(error, subprocess.CalledProcessError) else str(error)
        print(json.dumps({"ok": False, "error": detail or "Cannot change Bluetooth power"}))
        return 1
    print(json.dumps({"ok": True, "error": ""}))
    return 0


if __name__ == "__main__":
    sys.exit(main())
