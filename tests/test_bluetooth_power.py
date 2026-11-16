"""Bluetooth power ordering, radio scope, and error propagation."""
import importlib.util
from pathlib import Path
import subprocess
import unittest
from unittest.mock import patch

SCRIPT = Path(__file__).parents[1] / "home/.config/quickshell/scripts/bluetooth_power.py"
spec = importlib.util.spec_from_file_location("bluetooth_power", SCRIPT)
power = importlib.util.module_from_spec(spec)
spec.loader.exec_module(power)


class BluetoothPower(unittest.TestCase):
    def test_on_unblocks_only_bluetooth_before_powering_selected_adapter(self):
        with patch.object(power.subprocess, "run") as run:
            power.set_power("/org/bluez/hci1", True)
            self.assertEqual([call.args[0] for call in run.call_args_list], [
                ["rfkill", "unblock", "bluetooth"],
                ["busctl", "--system", "set-property", "org.bluez", "/org/bluez/hci1",
                 "org.bluez.Adapter1", "Powered", "b", "true"]])

    def test_off_does_not_unblock_or_block_radios(self):
        with patch.object(power.subprocess, "run") as run:
            power.set_power("/org/bluez/hci0", False)
            self.assertEqual(run.call_count, 1)
            self.assertEqual(run.call_args.args[0][-1], "false")

    def test_failed_unblock_does_not_attempt_power(self):
        with patch.object(power.subprocess, "run", side_effect=subprocess.CalledProcessError(
                1, ["rfkill"], stderr="Operation not permitted")) as run:
            with self.assertRaises(subprocess.CalledProcessError):
                power.set_power("/org/bluez/hci0", True)
            self.assertEqual(run.call_count, 1)

    def test_invalid_adapter_does_not_touch_radios(self):
        with patch.object(power.subprocess, "run") as run:
            with self.assertRaises(ValueError):
                power.set_power("/org/bluez/hci0/other", True)
            run.assert_not_called()


if __name__ == "__main__":
    unittest.main()
