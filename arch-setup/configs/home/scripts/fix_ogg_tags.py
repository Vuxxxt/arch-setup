#!/usr/bin/env python3
import sys
import base64
from io import BytesIO

from mutagen.oggopus import OggOpus
from mutagen.flac import Picture

try:
    from PIL import Image
except ImportError:
    print("Install Pillow: sudo pacman -S python-pillow")
    sys.exit(1)


def crop_square(data):
    img = Image.open(BytesIO(data))
    w, h = img.size
    m = min(w, h)
    img = img.crop(((w - m) // 2, (h - m) // 2, (w + m) // 2, (h + m) // 2))
    out = BytesIO()
    img.save(out, format="PNG")
    return out.getvalue()


def main(path):
    try:
        audio = OggOpus(path)
    except Exception as e:
        print(f"Error opening {path}: {e}")
        return

    tags = audio.tags or {}

    # ---- DATE (year only) ----
    date = tags.get("DATE", [None])[0]
    if date and date[:4].isdigit():
        tags["DATE"] = [date[:4]]
    else:
        if "DATE" in tags:
            del tags["DATE"]

    # ---- TRACKNUMBER (playlist_index only) ----
    track = tags.get("TRACKNUMBER", [None])[0]
    if track and track.isdigit():
        tags["TRACKNUMBER"] = [track.zfill(2)]
    else:
        if "TRACKNUMBER" in tags:
            del tags["TRACKNUMBER"]

    # ---- ARTIST / ALBUMARTIST ----
    artist = tags.get("ARTIST", [None])[0]
    if artist:
        parts = (
            artist.replace(" feat. ", ",")
                  .replace(" ft. ", ",")
                  .replace("&", ",")
                  .split(",")
        )
        parts = [p.strip() for p in parts if p.strip()]
        main_artist = parts[0]
        featured = parts[1:]

        tags["ARTIST"] = [main_artist]
        tags["ALBUMARTIST"] = [main_artist]

        if featured:
            tags["COMMENT"] = [f"Featuring: {', '.join(featured)}"]

    # ---- ALBUM ART ----
    if "metadata_block_picture" in tags:
        try:
            raw = tags["metadata_block_picture"][0]
            pic = Picture(base64.b64decode(raw))
            pic.data = crop_square(pic.data)
            tags["metadata_block_picture"] = [
                base64.b64encode(pic.write()).decode("ascii")
            ]
        except Exception as e:
            print(f"Album art failed: {e}")

    audio.tags = tags
    audio.save()
    print(f"Fixed tags: {path}")


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: fix_ogg_tags.py <file.opus>")
        sys.exit(1)
    main(sys.argv[1])
