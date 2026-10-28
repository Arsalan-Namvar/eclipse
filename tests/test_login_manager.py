"""Display-manager switching plans must preserve rollback and avoid live restarts."""
import importlib.util
from pathlib import Path
import subprocess
import tempfile
import unittest
from unittest.mock import patch

SCRIPT = Path(__file__).parents[1] / "home/.config/quickshell/scripts/login_manager.py"
spec = importlib.util.spec_from_file_location("login_manager", SCRIPT)
login = importlib.util.module_from_spec(spec)
spec.loader.exec_module(login)


class LoginEnablement(unittest.TestCase):
    def test_already_selected_sddm_preserves_original_rollback(self):
        with tempfile.TemporaryDirectory() as temp:
            state = Path(temp)
            previous = state / "latest.json"
            previous.write_text('{"previous":"Ly"}')
            with patch.object(login, "STATE", state), \
                    patch.object(login, "discover", return_value={"sddm.service": {"enabled": "enabled", "active": "active"}}), \
                    patch.object(login, "mutate", side_effect=AssertionError("must not change enablement")), \
                    patch.object(login.sys, "argv", ["login_manager.py", "--yes"]):
                login.main()
            self.assertEqual(previous.read_text(), '{"previous":"Ly"}')

    def test_failed_cutover_restores_previous_enablement(self):
        with tempfile.TemporaryDirectory() as temp:
            calls = []
            units = {"ly@tty2.service": {"enabled": "enabled", "active": "active"},
                     "sddm.service": {"enabled": "disabled", "active": "inactive"}}
            def operation(args, dry):
                self.assertNotIn("--now", args)
                self.assertFalse(set(args) & {"start", "stop", "restart"})
                calls.append(args)
                if args == ["enable", "sddm.service"]:
                    raise subprocess.CalledProcessError(1, args)
            with patch.object(login, "STATE", Path(temp)), patch.object(login, "discover", return_value=units), \
                    patch.object(login, "mutate", side_effect=operation), \
                    patch.object(login.sys, "argv", ["login_manager.py", "--yes"]):
                with self.assertRaises(subprocess.CalledProcessError):
                    login.main()
            self.assertIn(["enable", "ly@tty2.service"], calls)
            self.assertTrue((Path(temp) / "latest.json").exists())


if __name__ == "__main__":
    unittest.main()
