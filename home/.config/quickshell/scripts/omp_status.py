#!/usr/bin/env python3
"""Read only Eclipse extension snapshots, never OMP transcripts or credentials."""
import json
import os
import stat
import time
from pathlib import Path


def report():
    runtime = os.environ.get("XDG_RUNTIME_DIR")
    if not runtime:
        return {"sessions": [], "error": "XDG_RUNTIME_DIR is unavailable"}
    directory = Path(runtime) / "eclipse-omp"
    try:
        info = directory.lstat()
    except FileNotFoundError:
        return {"sessions": [], "error": ""}
    if not stat.S_ISDIR(info.st_mode) or info.st_uid != os.getuid() or info.st_mode & 0o077:
        return {"sessions": [], "error": "OMP status directory must be private and owned by you"}
    sessions = []
    for path in directory.glob("*.json"):
        try:
            descriptor = os.open(path, os.O_RDONLY | os.O_NOFOLLOW | os.O_NONBLOCK)
            with os.fdopen(descriptor, encoding="utf-8") as stream:
                info = os.fstat(stream.fileno())
                if not stat.S_ISREG(info.st_mode) or info.st_uid != os.getuid() or info.st_mode & 0o077 or info.st_size > 16384:
                    continue
                row = json.load(stream)
            if row.get("version") != 1 or not isinstance(row.get("id"), str):
                continue
            if row.get("state") not in ("idle", "working", "ended"):
                continue
            observed = row.get("observed")
            if not isinstance(observed, (int, float)):
                continue
            if row["state"] != "ended" and time.time() * 1000 - observed > 10000:
                row["state"] = "disconnected"
            sessions.append(row)
        except (OSError, ValueError, TypeError, AttributeError):
            continue
    sessions.sort(key=lambda row: (row.get("project", ""), row.get("name", ""), row["id"]))
    return {"sessions": sessions, "error": ""}


if __name__ == "__main__":
    try:
        print(json.dumps(report(), allow_nan=False))
    except (OSError, ValueError) as error:
        print(json.dumps({"sessions": [], "error": str(error)}))
