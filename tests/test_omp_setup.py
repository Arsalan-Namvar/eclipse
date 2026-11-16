"""Desktop PATH/cwd handling and safe local OMP package registration."""
import importlib.util
import json
import os
from pathlib import Path
import subprocess
import tempfile
import unittest
from unittest.mock import patch

SCRIPTS = Path(__file__).parents[1] / "home/.config/quickshell/scripts"
spec = importlib.util.spec_from_file_location("register_omp", SCRIPTS / "register_omp.py")
registration = importlib.util.module_from_spec(spec)
spec.loader.exec_module(registration)


class DesktopLaunch(unittest.TestCase):
    def test_graphical_path_and_directory_arguments(self):
        with tempfile.TemporaryDirectory() as temp:
            home = Path(temp) / "home with spaces"
            local = home / ".local/bin"
            local.mkdir(parents=True)
            omp = local / "omp"
            omp.write_text("#!/bin/sh\nexit 0\n")
            omp.chmod(0o755)
            commands = Path(temp) / "commands"
            commands.mkdir()
            kitty = commands / "kitty"
            kitty.write_text('#!/bin/bash\nprintf "%s\\0" "$@"\n')
            kitty.chmod(0o755)
            project = home / "project with spaces"
            project.mkdir()
            env = {"HOME": str(home), "PATH": f"{commands}:/usr/bin"}
            cases = [(project, ["--general"], home / "Work"),
                     (home, [], home / "Work"), (project, [], project)]
            for cwd, options, expected in cases:
                with self.subTest(cwd=cwd, options=options):
                    result = subprocess.run(["/bin/bash", str(SCRIPTS / "omp-launch.sh"),
                                             *options, "--profile", "test profile"],
                                            cwd=cwd, env=env, capture_output=True, check=True)
                    args = os.fsdecode(result.stdout).split("\0")[:-1]
                    self.assertEqual(args, ["--directory", str(expected), "--title", "OMP — Eclipse",
                                            str(omp), "--extension",
                                            str(home / ".omp/agent/extensions/eclipse"),
                                            "--profile", "test profile"])
                    self.assertTrue(expected.is_dir())


class PackageRegistration(unittest.TestCase):
    def test_links_package_and_preserves_existing_registration(self):
        with tempfile.TemporaryDirectory() as temp:
            home = Path(temp)
            package = home / ".omp/agent/extensions/eclipse"
            package.mkdir(parents=True)
            (package / "package.json").write_text('{"name":"eclipse-desktop"}')
            linked = home / "plugins/eclipse-desktop"
            linked.parent.mkdir()
            linked.symlink_to(package, target_is_directory=True)
            result = subprocess.CompletedProcess([], 0, stdout='{"npm":[]}')
            with patch.object(registration.Path, "home", return_value=home), \
                    patch.object(registration.shutil, "which", return_value="/bin/omp"), \
                    patch.object(registration.subprocess, "run", return_value=result) as run:
                registration.register(dry_run=True)
                self.assertEqual(run.call_count, 1)
                run.reset_mock()
                registration.register()
                self.assertEqual(run.call_args.args[0], ["/bin/omp", "plugin", "link", str(package)])
                result.stdout = json.dumps({"npm": [{"name": "eclipse-desktop", "path": str(linked),
                                                     "enabled": False}]})
                run.reset_mock()
                registration.register()
                self.assertEqual(run.call_count, 1)
                result.stdout = json.dumps({"npm": [{"name": "eclipse-desktop", "path": "/other/package"}]})
                run.reset_mock()
                with self.assertRaisesRegex(RuntimeError, "refusing to replace"):
                    registration.register()
                self.assertEqual(run.call_count, 1)


if __name__ == "__main__":
    unittest.main()
