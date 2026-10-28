"""Selected application setup preserves existing per-user configuration."""
import importlib.util
import os
from pathlib import Path
import subprocess
import tempfile
import unittest
from unittest.mock import patch

SCRIPT = Path(__file__).parents[1] / "home/.config/quickshell/scripts/app_integrations.py"
spec = importlib.util.spec_from_file_location("app_integrations", SCRIPT)
apps = importlib.util.module_from_spec(spec)
spec.loader.exec_module(apps)


class FileManagerActivation(unittest.TestCase):
    def test_uses_packaged_template_and_preserves_other_services(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            template = root / "packaged.service"
            template.write_text("[D-BUS Service]\nName=org.freedesktop.FileManager1\nExec=/usr/bin/strata --gapplication-service\n")
            data, state = root / "data", root / "state"
            services = data / "dbus-1/services"
            services.mkdir(parents=True)
            previous = services / "previous.service"
            previous.write_text("[D-BUS Service]\nName=org.freedesktop.FileManager1\nExec=previous\n")
            other = services / "unrelated.service"
            other.write_text("[D-BUS Service]\nName=example.Other\nExec=other\n")
            packaged_path = "/usr/share/dbus-1/services/io.github.lgse.Strata.FileManager1.service"

            def selected_path(value):
                return template if str(value) == packaged_path else Path(value)

            with patch.dict(os.environ, {"XDG_DATA_HOME": str(data), "XDG_STATE_HOME": str(state)}), \
                    patch.object(apps, "Path", side_effect=selected_path), \
                    patch.object(apps.subprocess, "run", return_value=subprocess.CompletedProcess([], 0)):
                apps.install_file_manager()
                installed = services / template.name
                self.assertEqual(installed.read_bytes(), template.read_bytes())
                self.assertFalse(previous.exists())
                self.assertEqual(len(list((state / "quickshell/app-backups").glob("filemanager-*/previous.service"))), 1)
                self.assertIn("Name=example.Other", other.read_text())
                apps.install_file_manager()
                self.assertEqual(len(list((state / "quickshell/app-backups").glob("filemanager-*"))), 1)


if __name__ == "__main__":
    unittest.main()
