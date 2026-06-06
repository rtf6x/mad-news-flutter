#!/usr/bin/env python3
"""Generate opaque iOS AppIcon assets from assets/app_icon.png."""

from __future__ import annotations

import struct
import subprocess
import zlib
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "assets" / "app_icon.png"
MASTER = ROOT / "assets" / "app_icon_ios.png"
OUT_DIR = ROOT / "ios" / "Runner" / "Assets.xcassets" / "AppIcon.appiconset"

SIZES = {
    "Icon-App-20x20@1x.png": 20,
    "Icon-App-20x20@2x.png": 40,
    "Icon-App-20x20@3x.png": 60,
    "Icon-App-29x29@1x.png": 29,
    "Icon-App-29x29@2x.png": 58,
    "Icon-App-29x29@3x.png": 87,
    "Icon-App-40x40@1x.png": 40,
    "Icon-App-40x40@2x.png": 80,
    "Icon-App-40x40@3x.png": 120,
    "Icon-App-50x50@1x.png": 50,
    "Icon-App-50x50@2x.png": 100,
    "Icon-App-57x57@1x.png": 57,
    "Icon-App-57x57@2x.png": 114,
    "Icon-App-60x60@2x.png": 120,
    "Icon-App-60x60@3x.png": 180,
    "Icon-App-72x72@1x.png": 72,
    "Icon-App-72x72@2x.png": 144,
    "Icon-App-76x76@1x.png": 76,
    "Icon-App-76x76@2x.png": 152,
    "Icon-App-83.5x83.5@2x.png": 167,
    "Icon-App-1024x1024@1x.png": 1024,
}


def read_png_rgba(path: Path) -> tuple[int, int, list[list[tuple[int, int, int, int]]]]:
    with path.open("rb") as f:
        assert f.read(8) == b"\x89PNG\r\n\x1a\n"
        idat = b""
        width = height = 0
        color = 0
        while True:
            length_bytes = f.read(4)
            if not length_bytes:
                break
            length = struct.unpack(">I", length_bytes)[0]
            chunk_type = f.read(4).decode()
            data = f.read(length)
            f.read(4)
            if chunk_type == "IHDR":
                width, height, _, color, *_ = struct.unpack(">IIBBBBB", data)
            elif chunk_type == "IDAT":
                idat += data

    bpp = 4 if color == 6 else 3
    raw = zlib.decompress(idat)
    offset = 0
    pixels: list[list[tuple[int, int, int, int]]] = []
    for _ in range(height):
        offset += 1
        row = raw[offset : offset + width * bpp]
        offset += width * bpp
        out_row: list[tuple[int, int, int, int]] = []
        for x in range(width):
            base = x * bpp
            if bpp == 4:
                r, g, b, a = row[base : base + 4]
            else:
                r, g, b = row[base : base + 3]
                a = 255
            out_row.append((r, g, b, a))
        pixels.append(out_row)
    return width, height, pixels


def write_png_rgb(path: Path, width: int, height: int, pixels: list[list[tuple[int, int, int]]]) -> None:
    def chunk(tag: bytes, data: bytes) -> bytes:
        return struct.pack(">I", len(data)) + tag + data + struct.pack(">I", zlib.crc32(tag + data) & 0xFFFFFFFF)

    ihdr = struct.pack(">IIBBBBB", width, height, 8, 2, 0, 0, 0)
    raw = b"".join(b"\x00" + b"".join(bytes(pixels[y][x]) for x in range(width)) for y in range(height))
    path.write_bytes(b"\x89PNG\r\n\x1a\n" + chunk(b"IHDR", ihdr) + chunk(b"IDAT", zlib.compress(raw, 9)) + chunk(b"IEND", b""))


def composite(source: list[list[tuple[int, int, int, int]]], background: tuple[int, int, int]) -> list[list[tuple[int, int, int]]]:
    output: list[list[tuple[int, int, int]]] = []
    for row in source:
        out_row: list[tuple[int, int, int]] = []
        for r, g, b, a in row:
            t = a / 255
            out_row.append(
                (
                    int(r * t + background[0] * (1 - t)),
                    int(g * t + background[1] * (1 - t)),
                    int(b * t + background[2] * (1 - t)),
                )
            )
        output.append(out_row)
    return output


def main() -> None:
    width, height, source = read_png_rgba(SOURCE)
    background = source[height // 2][width // 4][:3]
    opaque = composite(source, background)

    write_png_rgb(MASTER.with_suffix(".tmp.png"), width, height, opaque)
    subprocess.run(["sips", "-z", "1024", "1024", str(MASTER.with_suffix(".tmp.png")), "--out", str(MASTER)], check=True)
    MASTER.with_suffix(".tmp.png").unlink(missing_ok=True)

    for filename, size in SIZES.items():
        subprocess.run(["sips", "-z", str(size), str(size), str(MASTER), "--out", str(OUT_DIR / filename)], check=True)

    print(f"Generated {len(SIZES)} icons from {SOURCE}")


if __name__ == "__main__":
    main()
