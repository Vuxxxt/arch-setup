#!/usr/bin/env python3
import sys
import base64
from io import BytesIO

from mutagen.oggopus import OggOpus
from mutagen.flac import Picture

from PIL import Image

# ------------------------
# Helpers
# ------------------------

def clean_text(text):
    if not text:
        return None
    return text.strip()

def clean_title(title):
    if not title:
        return "Unknown Title"

    remove_patterns = [
        "(Official Video)",
        "(Official Audio)",
        "(Lyrics)",
        "[Official Video]",
        "[Official Audio]",
        "[HD]",
        "[4K]"
    ]

    for pattern in remove_patterns:
        title = title.replace(pattern, "")

    return title.strip()

def split_artist(artist):
    if not artist:
        return "Unknown Artist", []

    artist = artist.replace(" - Topic", "")

    separators = [" feat. ", " ft. ", "&", ","]
    for sep in separators:
        artist = artist.replace(sep, ",")

    parts = [p.strip() for p in artist.split(",") if p.strip()]

    main = parts[0] if parts else "Unknown Artist"
    featured = parts[1:] if len(parts) > 1 else []

    return main, featured

def extract_year(date):
    if not date:
        return None

    date = str(date)

    if len(date) >= 4 and date[:4].isdigit():
        return date[:4]

    return None

# ------------------------
# Image crop
# ------------------------

def crop_square(data):
    img = Image.open(BytesIO(data))
    w, h = img.size
    m = min(w, h)

    img = img.crop(
        (
            (w - m) // 2,
            (h - m) // 2,
            (w + m) // 2,
            (h + m) // 2
        )
    )

    out = BytesIO()
    img.save(out, format="PNG")
    return out.getvalue()

# ------------------------
# Main
# ------------------------

def main(path):
    try:
        audio = OggOpus(path)
    except Exception as e:
        print(f"Error reading {path}: {e}")
        return

    tags = audio.tags or {}

    raw_artist = tags.get("ARTIST", [None])[0]
    raw_title = tags.get("TITLE", [None])[0]
    raw_album = tags.get("ALBUM", [None])[0]
    raw_track = tags.get("TRACKNUMBER", [None])[0]
    raw_date = tags.get("DATE", [None])[0]

    # --- Clean values ---
    main_artist, featured = split_artist(raw_artist)
    title = clean_title(raw_title)
    album = clean_text(raw_album) or "Unknown Album"
    year = extract_year(raw_date)

    # --- FORCE CONSISTENCY ---
    tags["TITLE"] = [title]
    tags["ARTIST"] = [main_artist]
    tags["ALBUMARTIST"] = [main_artist]
    tags["ALBUM"] = [album]

    # --- Track number ---
    if raw_track and str(raw_track).isdigit():
        tags["TRACKNUMBER"] = [str(raw_track).zfill(2)]
    else:
        tags["TRACKNUMBER"] = ["01"]

    # --- Year fix ---
    if year:
        tags["DATE"] = [year]
        tags["YEAR"] = [year]

    # --- Featured artists ---
    if featured:
        tags["COMMENT"] = [f"Feat: {', '.join(featured)}"]

    # ------------------------
    # Album art crop fix
    # ------------------------
    if "METADATA_BLOCK_PICTURE" in tags:
        try:
            pic_data = base64.b64decode(tags["METADATA_BLOCK_PICTURE"][0])
            pic = Picture(pic_data)

            cropped = crop_square(pic.data)

            new_pic = Picture()
            new_pic.type = pic.type
            new_pic.mime = "image/png"
            new_pic.desc = pic.desc

            img = Image.open(BytesIO(cropped))
            new_pic.width, new_pic.height = img.size
            new_pic.depth = 24
            new_pic.data = cropped

            # FIXED: correct Mutagen usage
            tags["METADATA_BLOCK_PICTURE"] = [
                base64.b64encode(new_pic.write()).decode("utf-8")
            ]

        except Exception as e:
            print(f"Thumbnail crop failed: {e}")

    audio.tags = tags
    audio.save()

    print(f"Fixed: {path}")

# ------------------------
# Entry
# ------------------------

if __name__ == "__main__":
    if len(sys.argv) < 2:
        sys.exit("Usage: fix_ogg_tags.py <file>")
    main(sys.argv[1])