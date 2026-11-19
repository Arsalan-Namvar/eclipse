"""Saved Bluetooth devices stay visible without scanning or live hardware."""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest


class BluetoothDevices(unittest.TestCase):
    @unittest.skipUnless(shutil.which("qs"), "Quickshell is required for the QML regression")
    def test_disconnected_paired_devices_remain_listed(self):
        root = Path(__file__).parents[1]
        with tempfile.TemporaryDirectory() as temp:
            config = Path(temp) / "quickshell"
            shutil.copytree(root / "home/.config/quickshell", config)
            shutil.copyfile(root / "tests/bluetooth_devices.qml", config / "bluetooth_devices.qml")
            env = os.environ.copy()
            env.pop("WAYLAND_DISPLAY", None)
            env.pop("HYPRLAND_INSTANCE_SIGNATURE", None)
            env.update(QT_QPA_PLATFORM="offscreen", XDG_STATE_HOME=temp,
                       DBUS_SYSTEM_BUS_ADDRESS="unix:path=" + temp + "/no-system-bus")
            result = subprocess.run(["qs", "-p", str(config / "bluetooth_devices.qml"), "--no-color"],
                                    env=env, capture_output=True, text=True, timeout=20)
            output = result.stdout + result.stderr
            self.assertEqual(result.returncode, 0, output)
            self.assertIn("BLUETOOTH_DEVICES_PASSED", output)


if __name__ == "__main__":
    unittest.main()
