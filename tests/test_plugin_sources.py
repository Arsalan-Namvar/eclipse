"""Real Git repositories: exact revision, shallow modules and cache reuse."""
import importlib.util
import os
from pathlib import Path
import subprocess
import tempfile
import unittest
from unittest.mock import patch

SCRIPT = Path(__file__).parents[1] / "home/.config/quickshell/scripts/plugin_sources.py"
spec = importlib.util.spec_from_file_location("plugin_sources", SCRIPT)
sources = importlib.util.module_from_spec(spec)
spec.loader.exec_module(sources)


def git(path, *args, env=None):
    return subprocess.check_output(["git", "-C", str(path), *args], text=True,
                                   stderr=subprocess.DEVNULL, env=env).strip()


class PluginSources(unittest.TestCase):
    def test_exact_old_revision_and_submodule_survive_local_hyprpm_clone(self):
        with tempfile.TemporaryDirectory() as directory:
            base = Path(directory)
            module, upstream = base / "module", base / "upstream"
            for repo in (module, upstream):
                repo.mkdir()
                git(repo, "init", "--quiet")
                git(repo, "config", "user.email", "test@example.invalid")
                git(repo, "config", "user.name", "Test")
            (module / "header.h").write_text("pinned module\n")
            git(module, "add", ".")
            git(module, "commit", "-qm", "module pin")
            module_pin = git(module, "rev-parse", "HEAD")
            git(upstream, "-c", "protocol.file.allow=always", "submodule", "add",
                module.as_uri(), "subprojects/module")
            (upstream / "header.h").write_text("installed version\n")
            git(upstream, "add", ".")
            git(upstream, "commit", "-qm", "installed version")
            pin = git(upstream, "rev-parse", "HEAD")
            (upstream / "header.h").write_text("new incompatible version\n")
            git(upstream, "commit", "-qam", "new upstream head")
            with patch.dict(os.environ, {"GIT_CONFIG_COUNT": "1",
                                        "GIT_CONFIG_KEY_0": "protocol.file.allow",
                                        "GIT_CONFIG_VALUE_0": "always"}):
                prepared = sources.prepare(base / "cache", pin, upstream.as_uri())
            self.assertEqual(git(prepared, "rev-parse", "HEAD"), pin)
            self.assertEqual(git(prepared, "rev-list", "--count", "HEAD"), "1")
            self.assertEqual((prepared / "header.h").read_text(), "installed version\n")
            # The upstream can disappear after preparation; repeat must reuse
            # the cached exact root/module, not silently fetch latest HEAD.
            upstream.rename(base / "offline-upstream")
            module.rename(base / "offline-module")
            with patch.dict(os.environ, {"GIT_CONFIG_COUNT": "1",
                                        "GIT_CONFIG_KEY_0": "protocol.file.allow",
                                        "GIT_CONFIG_VALUE_0": "always"}):
                sources.prepare(base / "cache", pin, upstream.as_uri())
            env = sources.local_submodules(prepared, os.environ)
            clone = base / "hyprpm-clone"
            git(base, "clone", "--recursive", prepared.as_uri(), str(clone), env=env)
            git(clone, "checkout", pin, env=env)
            git(clone, "reset", "--hard", "--recurse-submodules", pin, env=env)
            self.assertEqual(git(clone, "rev-parse", "HEAD"), pin)
            self.assertEqual(git(clone / "subprojects/module", "rev-parse", "HEAD"), module_pin)
            self.assertEqual((clone / "subprojects/module/header.h").read_text(), "pinned module\n")

    def test_invalid_revision_does_not_create_source_tree(self):
        with tempfile.TemporaryDirectory() as directory:
            with self.assertRaises(ValueError):
                sources.prepare(directory, "main; invalid")
            self.assertEqual(list(Path(directory).iterdir()), [])


if __name__ == "__main__":
    unittest.main()
