"""Private runtime snapshots: lifecycle and file-boundary behavior, no OMP account."""
import importlib.util
import json
import os
from pathlib import Path
import tempfile
import time
import unittest
from unittest.mock import patch

SCRIPT = Path(__file__).parents[1] / "home/.config/quickshell/scripts/omp_status.py"
spec = importlib.util.spec_from_file_location("omp_status", SCRIPT)
status = importlib.util.module_from_spec(spec)
spec.loader.exec_module(status)


class SnapshotBoundary(unittest.TestCase):
    def test_live_stale_ended_and_unsafe_files(self):
        with tempfile.TemporaryDirectory() as temp:
            directory = Path(temp) / "eclipse-omp"
            directory.mkdir(mode=0o700)
            now = time.time() * 1000
            for name, state, age in [("live", "idle", 0), ("stale", "working", 20000), ("ended", "ended", 20000)]:
                path = directory / (name + ".json")
                path.write_text(json.dumps(dict(version=1, id=name, state=state, observed=now-age, project="/sample")))
                path.chmod(0o600)
            public = directory / "public.json"
            public.write_text(json.dumps(dict(version=1, id="unsafe", state="idle", observed=now)))
            public.chmod(0o644)
            (directory / "symlink.json").symlink_to(directory / "live.json")
            with patch.dict(os.environ, {"XDG_RUNTIME_DIR": temp}):
                rows = {row["id"]: row["state"] for row in status.report()["sessions"]}
                self.assertEqual(rows, {"live": "idle", "stale": "disconnected", "ended": "ended"})
                directory.chmod(0o755)
                denied = status.report()
                self.assertEqual(denied["sessions"], [])
                self.assertIn("private", denied["error"])


if __name__ == "__main__":
    unittest.main()
