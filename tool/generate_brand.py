"""Generate original bubble-mark PNGs using only Python's standard library."""
from pathlib import Path
import struct
import zlib


def chunk(kind, data):
    return struct.pack('!I', len(data)) + kind + data + struct.pack('!I', zlib.crc32(kind + data))


def icon(size):
    pixels = bytearray()
    for y in range(size):
        pixels.append(0)
        for x in range(size):
            light = any((x / size - cx) ** 2 + (y / size - cy) ** 2 <= r ** 2
                        for cx, cy, r in [(0.61, 0.32, 0.17), (0.31, 0.57, 0.13), (0.61, 0.74, 0.09)])
            pixels.extend((225, 237, 204) if light else (24, 63, 53))
    return (b'\x89PNG\r\n\x1a\n' + chunk(b'IHDR', struct.pack('!2I5B', size, size, 8, 2, 0, 0, 0))
            + chunk(b'IDAT', zlib.compress(pixels)) + chunk(b'IEND', b''))


root = Path(__file__).resolve().parents[1]
for size in (32, 192, 512):
    paths = ['web/favicon.png'] if size == 32 else [f'web/icons/Icon-{size}.png', f'web/icons/Icon-maskable-{size}.png']
    for path in paths:
        (root / path).write_bytes(icon(size))
