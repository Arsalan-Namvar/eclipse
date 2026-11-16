"""Run the real QML workspace model without a live compositor or user state."""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest


class NumberedWorkspaces(unittest.TestCase):
    @unittest.skipUnless(shutil.which("qs"), "Quickshell is required for the QML regression")
    def test_scratchpad_keeps_each_monitors_numbered_strip(self):
        root = Path(__file__).parents[1]
        with tempfile.TemporaryDirectory() as temp:
            config = Path(temp) / "quickshell"
            shutil.copytree(root / "home/.config/quickshell", config)
            shutil.copytree(root / "home/.config/hypr", Path(temp) / "hypr")
            shutil.copyfile(root / "tests/workspace_state.qml", config / "workspace_state.qml")
            env = os.environ.copy()
            env.pop("HYPRLAND_INSTANCE_SIGNATURE", None)
            env.pop("WAYLAND_DISPLAY", None)
            env.update(QT_QPA_PLATFORM="offscreen", XDG_STATE_HOME=temp)
            result = subprocess.run(["qs", "-p", str(config / "workspace_state.qml"), "--no-color"],
                                    env=env, capture_output=True, text=True, timeout=20)
            output = result.stdout + result.stderr
            self.assertEqual(result.returncode, 0, output)
            self.assertIn("WORKSPACE_STATE_PASSED", output)
            self.assertNotIn("FAIL!", output)


if __name__ == "__main__":
    unittest.main()
