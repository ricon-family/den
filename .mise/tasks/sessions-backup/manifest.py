#!/usr/bin/env python3
"""Build a manifest JSON describing a backup tarball's contents.

Usage:
    manifest.py <source_root> <out_path> [<filelist>]

If <filelist> is omitted, walks every regular file under <source_root>.
If provided, reads relative paths (one per line) from that file; non-existent
entries are skipped silently.

The manifest is meant to live alongside the tarball in B2 storage so we can
inspect contents without downloading the (potentially large) tarball.
"""

from __future__ import annotations

import json
import os
import sys
from datetime import datetime, timezone


def iso(ts: int) -> str:
    return datetime.fromtimestamp(ts, tz=timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")


def main() -> int:
    if len(sys.argv) < 3:
        print("usage: manifest.py <source_root> <out_path> [<filelist>]", file=sys.stderr)
        return 2

    root = os.path.abspath(sys.argv[1])
    out_path = sys.argv[2]
    filelist = sys.argv[3] if len(sys.argv) > 3 else None

    if filelist:
        with open(filelist, "r", encoding="utf-8") as f:
            rels = [line.rstrip("\n") for line in f if line.strip()]
        paths = [(rel, os.path.join(root, rel)) for rel in rels]
    else:
        paths = []
        for dirpath, _, names in os.walk(root):
            for name in names:
                p = os.path.join(dirpath, name)
                rel = os.path.relpath(p, root)
                paths.append((rel, p))

    files = []
    total_bytes = 0
    earliest = None
    latest = None
    for rel, p in paths:
        try:
            st = os.stat(p)
        except OSError:
            continue
        mtime = int(st.st_mtime)
        files.append({"path": rel, "size": st.st_size, "mtime": mtime})
        total_bytes += st.st_size
        if earliest is None or mtime < earliest:
            earliest = mtime
        if latest is None or mtime > latest:
            latest = mtime

    # Chronological order so the manifest reads naturally from oldest to newest.
    files.sort(key=lambda e: e["mtime"])

    manifest = {
        "created_at": iso(int(datetime.now(tz=timezone.utc).timestamp())),
        "source_root": root,
        "file_count": len(files),
        "total_bytes": total_bytes,
        "earliest_mtime": iso(earliest) if earliest is not None else None,
        "latest_mtime": iso(latest) if latest is not None else None,
        "files": files,
    }

    with open(out_path, "w", encoding="utf-8") as out:
        json.dump(manifest, out, indent=2)
        out.write("\n")

    # Brief stderr summary so the caller can show progress.
    print(
        f"manifest: {len(files)} files, {total_bytes} bytes, "
        f"{manifest['earliest_mtime']} → {manifest['latest_mtime']}",
        file=sys.stderr,
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())
