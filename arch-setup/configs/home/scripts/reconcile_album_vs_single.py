#!/usr/bin/env python3
import sys
from pathlib import Path
from mutagen.oggopus import OggOpus

MUSIC_ROOT = Path.home() / "Music"


def remove_empty_parents(path: Path):
    while path != MUSIC_ROOT:
        try:
            path.rmdir()
            path = path.parent
        except OSError:
            break


def get_tags(path: Path):
    try:
        audio = OggOpus(path)
        tags = audio.tags or {}
        title = tags.get("TITLE", [None])[0]
        artist = tags.get("ARTIST", [None])[0]
        album = tags.get("ALBUM", [None])[0]
        return title, artist, album
    except Exception:
        return None, None, None


def is_album_track(album, title):
    if not album:
        return False
    if album.strip().lower() == title.strip().lower():
        return False
    return True


def main(file_path: Path):
    if not file_path.exists():
        return

    title, artist, album = get_tags(file_path)
    if not title or not artist:
        return

    current_is_album = is_album_track(album, title)
    current_dir = file_path.parent

    for other in MUSIC_ROOT.rglob("*.opus"):
        if other == file_path:
            continue

        t, a, al = get_tags(other)
        if t == title and a == artist:
            other_is_album = is_album_track(al, t)

            # Album replaces single
            if current_is_album and not other_is_album:
                print(f"Removing single (album preferred): {other}")
                other.unlink(missing_ok=True)
                remove_empty_parents(other.parent)

            # Skip single if album already exists
            if not current_is_album and other_is_album:
                print(f"Skipping single (album already exists): {file_path}")
                file_path.unlink(missing_ok=True)
                remove_empty_parents(current_dir)
                return


if __name__ == "__main__":
    if len(sys.argv) < 2:
        sys.exit(0)

    main(Path(sys.argv[1]))