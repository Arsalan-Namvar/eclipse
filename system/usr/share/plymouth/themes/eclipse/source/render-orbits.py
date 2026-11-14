#!/usr/bin/env python3
"""Original Eclipse orbital bands, GPL-3.0-or-later.

Render one loop as paired near/far PNGs for Plymouth's sprite layers. Requires
rsvg-convert. Run from any directory; outputs ../orbits/{back,front}-NN.png.
The approved emblem is not modified. No network, font or image dependencies.
"""
import math
from pathlib import Path
import subprocess

FRAMES = 64
SAMPLES = 192
SIZE = 400
ROOT = Path(__file__).resolve().parent.parent


def point(t, phase, ring):
    radius = 158 if ring == 0 else 174
    tilt = math.radians(66 if ring == 0 else -58)
    yaw = phase if ring == 0 else -phase + math.pi / 3
    x, y, z = radius * math.cos(t), radius * math.sin(t), 0
    # Incline the orbital plane, then precess it around the vertical axis.
    y, z = y * math.cos(tilt), y * math.sin(tilt)
    x, z = x * math.cos(yaw) + z * math.sin(yaw), -x * math.sin(yaw) + z * math.cos(yaw)
    # Fixed opposing screen inclination distinguishes the two orbital planes.
    roll = math.radians(-32 if ring == 0 else 38)
    x, y = x * math.cos(roll) - y * math.sin(roll), x * math.sin(roll) + y * math.cos(roll)
    return x + SIZE / 2, y + SIZE / 2, z


def paths(phase, front):
    result = []
    for ring in range(2):
        commands = []
        for i in range(SAMPLES):
            a = point(i * 2 * math.pi / SAMPLES, phase, ring)
            b = point((i + 1) * 2 * math.pi / SAMPLES, phase, ring)
            # Split exactly at the depth plane, so near/far halves join without
            # an opacity crossfade or a line drawn through the hidden hemisphere.
            if (a[2] >= 0) != (b[2] >= 0):
                f = a[2] / (a[2] - b[2])
                mid = (a[0] + f * (b[0] - a[0]), a[1] + f * (b[1] - a[1]), 0)
                if (a[2] >= 0) == front:
                    b = mid
                else:
                    a = mid
            elif (a[2] >= 0) != front:
                continue
            commands.append(f'M{a[0]:.3f},{a[1]:.3f}L{b[0]:.3f},{b[1]:.3f}')
        color = '#cbbb92' if ring == 0 else '#a29bb8'
        result.append(f'<path d="{" ".join(commands)}" stroke="{color}"/>')
    return ''.join(result)


def main():
    output = ROOT / 'orbits'
    output.mkdir(exist_ok=True)
    for frame in range(FRAMES):
        phase = frame * 2 * math.pi / FRAMES
        for side in ('back', 'front'):
            svg = (f'<svg xmlns="http://www.w3.org/2000/svg" width="{SIZE}" height="{SIZE}" '
                   f'viewBox="0 0 {SIZE} {SIZE}" fill="none" stroke-width="2.4" stroke-linecap="round">'
                   + paths(phase, side == 'front') + '</svg>')
            subprocess.run(['rsvg-convert', '-o', str(output / f'{side}-{frame:02d}.png')],
                           input=svg.encode(), check=True)
    print(f'Rendered {FRAMES} paired orbital frames in {output}')


if __name__ == '__main__':
    main()
