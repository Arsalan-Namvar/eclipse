"""Exercise the actual OMP selector model without user sessions or a desktop."""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest


class OmpSessionLifecycle(unittest.TestCase):
    @unittest.skipUnless(shutil.which("qs"), "Quickshell is required for the QML regression")
    def test_ended_sessions_are_removed_without_switching_selection(self):
        root = Path(__file__).parents[1]
        with tempfile.TemporaryDirectory() as temp:
            config = Path(temp) / "quickshell"
            shutil.copytree(root / "home/.config/quickshell", config)
            shutil.copyfile(root / "tests/omp_sessions.qml", config / "omp_sessions.qml")
            env = os.environ.copy()
            env.pop("HYPRLAND_INSTANCE_SIGNATURE", None)
            env.pop("WAYLAND_DISPLAY", None)
            env.update(QT_QPA_PLATFORM="offscreen", XDG_STATE_HOME=temp, XDG_RUNTIME_DIR=temp)
            result = subprocess.run(["qs", "-p", str(config / "omp_sessions.qml"), "--no-color"],
                                    env=env, capture_output=True, text=True, timeout=20)
            output = result.stdout + result.stderr
            self.assertEqual(result.returncode, 0, output)
            self.assertIn("OMP_SESSIONS_PASSED", output)


if __name__ == "__main__":
    unittest.main()
