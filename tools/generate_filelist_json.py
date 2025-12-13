
#!/usr/bin/env python3
import os
import json
from pathlib import Path

# リポジトリのルートからの相対パスを前提にしてる想定
ROOT = Path(__file__).resolve().parents[1]  # tools/ の1個上 = repo root
APP_DIR = ROOT / "Illustration Viewer"
ILLUST_DIR = APP_DIR / "Illustrations"
OUTPUT_JSON = APP_DIR / "illustration_list.json"

def main():
    if not ILLUST_DIR.exists():
        raise SystemExit(f"Illustrations folder not found: {ILLUST_DIR}")

    png_files = sorted(
        p for p in ILLUST_DIR.iterdir()
        if p.suffix.lower() == ".png"
    )

    seeds = []
    for p in png_files:
        id_ = p.stem  # "001.png" -> "001"
        seeds.append({
            "id": id_,
            "filename": p.name,
            "tagIDs": [],
            "rating": 0
        })

    OUTPUT_JSON.write_text(
        json.dumps(seeds, ensure_ascii=False, indent=2, sort_keys=True),
        encoding="utf-8"
    )
    print(f"Wrote {len(seeds)} records to {OUTPUT_JSON}")

if __name__ == "__main__":
    main()
