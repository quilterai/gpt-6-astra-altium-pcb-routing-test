"""Check proposed DDR copper against exported primitives without editing the board."""

import csv
import json
import math
import struct
from pathlib import Path

OUT = Path(__file__).resolve().parent
ROOT = OUT.parents[2]
ORIGIN = (115633500, 82894100)


def table(path):
    """Read an Altium tab-separated inventory."""
    with path.open(encoding="utf-8-sig", newline="") as handle:
        return list(csv.DictReader(handle, delimiter="\t"))


def point(x, y):
    """Convert internal coordinates to board-relative mils."""
    return ((float(x) - ORIGIN[0]) / 10000, (float(y) - ORIGIN[1]) / 10000)


def raw_point(p):
    """Convert board-relative mils to exact integer internal coordinates."""
    return [round(p[i] * 10000 + ORIGIN[i]) for i in range(2)]


def point_segment(p, a, b):
    """Return distance from a point to a finite line segment."""
    dx, dy = b[0] - a[0], b[1] - a[1]
    length2 = dx * dx + dy * dy
    t = max(0, min(1, ((p[0] - a[0]) * dx + (p[1] - a[1]) * dy) / length2)) if length2 else 0
    return math.hypot(p[0] - a[0] - t * dx, p[1] - a[1] - t * dy)


def segment_segment(a, b, c, d):
    """Return the minimum distance between two finite line segments."""
    def orient(p, q, r):
        return (q[0] - p[0]) * (r[1] - p[1]) - (q[1] - p[1]) * (r[0] - p[0])
    if orient(a, b, c) * orient(a, b, d) < 0 and orient(c, d, a) * orient(c, d, b) < 0:
        return 0
    return min(point_segment(a, c, d), point_segment(b, c, d), point_segment(c, a, b), point_segment(d, a, b))


def inside(p, polygon):
    """Apply the odd-even test to a polygon without self-intersections."""
    result = False
    for a, b in zip(polygon, polygon[1:] + polygon[:1]):
        if (a[1] > p[1]) != (b[1] > p[1]):
            crossing = (b[0] - a[0]) * (p[1] - a[1]) / (b[1] - a[1]) + a[0]
            if p[0] < crossing:
                result = not result
    return result


def segment_polygon(a, b, polygon):
    """Return distance between a segment and a filled polygon."""
    if inside(a, polygon) or inside(b, polygon):
        return 0
    return min(segment_segment(a, b, c, d) for c, d in zip(polygon, polygon[1:] + polygon[:1]))


def rectangle(center, x_size, y_size, rotation):
    """Return corners of an oriented pad bounding rectangle."""
    c, s = math.cos(math.radians(rotation)), math.sin(math.radians(rotation))
    return [(center[0] + x * c - y * s, center[1] + x * s + y * c) for x, y in [(-x_size/2, -y_size/2), (x_size/2, -y_size/2), (x_size/2, y_size/2), (-x_size/2, y_size/2)]]


def original_records():
    """Read original geometry; requires olefile and the original run exports."""
    import olefile

    parts = json.loads((OUT / "Components6.json").read_text())
    shapes = {}
    regions = []
    with olefile.OleFileIO(ROOT / "projects/input/QCMI_SOM8MM/IMX8MMLPD4-CPU2_FULLY_PREPLACED_FANOUT.PcbDoc", write_mode=False) as doc:
        data = doc.openstream("Pads6/Data").read()
        offset = 0
        while offset < len(data):
            assert data[offset] == 2
            offset += 1
            chunks = []
            for _ in range(6):
                length = struct.unpack_from("<I", data, offset)[0] & 0xFFFFFF
                offset += 4
                chunks.append(data[offset:offset+length])
                offset += length
            block = chunks[4]
            component = struct.unpack_from("<H", block, 7)[0]
            ref = parts[component]["SOURCEDESIGNATOR"] if component < len(parts) else ""
            pad = chunks[0][1:].decode("latin1")
            shapes[(ref, pad)] = {"shape": block[49], "x_size": struct.unpack_from("<i", block, 21)[0] / 10000, "y_size": struct.unpack_from("<i", block, 25)[0] / 10000}
        data = doc.openstream("Regions6/Data").read()
        offset = 0
        while offset < len(data):
            assert data[offset] == 11
            length = struct.unpack_from("<I", data, offset+1)[0] & 0xFFFFFF
            offset += 5
            block = data[offset:offset+length]
            offset += length
            text_size = struct.unpack_from("<I", block, 18)[0]
            fields = {k: v for item in block[22:22+text_size].decode("latin1").rstrip("\x00").split("|") if "=" in item for k, v in [item.split("=", 1)]}
            p = 22 + text_size
            count = struct.unpack_from("<I", block, p)[0]
            p += 4
            vertices = [point(*struct.unpack_from("<dd", block, p + i * 16)) for i in range(count)]
            p += count * 16
            holes = []
            for _ in range(struct.unpack_from("<H", block, 14)[0]):
                count = struct.unpack_from("<I", block, p)[0]
                p += 4
                holes.append([point(*struct.unpack_from("<dd", block, p + i * 16)) for i in range(count)])
                p += count * 16
            assert p == len(block), (p, len(block))
            regions.append({"index": len(regions), "layer": block[0], "keepout": int(fields.get("KEEPOUTRESTRICTIONS", 0)), "polygon_index": struct.unpack_from("<H", block, 5)[0], "vertices": vertices, "holes": holes, "fields": fields})
    return shapes, regions


class Geometry:
    """Represent exported pads, tracks, vias, and original keepout geometry."""

    def __init__(self, inventory):
        self.pads = table(inventory / "pads.tsv")
        self.tracks = table(inventory / "tracks.tsv")
        self.vias = table(inventory / "vias.tsv")
        self.shapes, self.regions = original_records()

    def apply_proposed_edits(self, path):
        """Apply a scratch FullTracks proposal to this in-memory model only."""
        for edit in table(path):
            if edit["action"] == "edit":
                matches = [t for t in self.tracks if all(t[key] == edit["old_" + key] for key in ["x1_raw", "y1_raw", "x2_raw", "y2_raw"]) and all(t[key] == edit[key] for key in ["net", "width_raw", "layer_id"])]
                assert len(matches) == 1
                target = matches[0]
            else:
                target = {"net": edit["net"], "width_raw": edit["width_raw"], "layer_id": edit["layer_id"], "layer": "Top Layer" if edit["layer_id"] == "1" else "Bottom Layer", "selected": "false"}
                self.tracks.append(target)
            target.update({key: edit["new_" + key] for key in ["x1_raw", "y1_raw", "x2_raw", "y2_raw"]})

    def check(self, net, a, b, radius, layer=None, ignore_tracks=()):
        """Return conservative primitive and keepout clearance observations."""
        observations = []
        for p in self.pads:
            if p["net"] == net or (layer is not None and int(p["layer_id"]) not in {layer, 74}):
                continue
            center = point(p["x_raw"], p["y_raw"])
            shape = self.shapes[(p["refdes"], p["pad"])]
            xs, ys = float(p["top_x_size_raw"]) / 10000, float(p["top_y_size_raw"]) / 10000
            if shape["shape"] == 1 and xs == ys:
                distance = point_segment(center, a, b) - xs / 2 - radius
            else:
                distance = segment_polygon(a, b, rectangle(center, xs, ys, float(p["rotation_degrees"]))) - radius
            observations.append((distance, "pad", p["refdes"] + "-" + p["pad"], p["net"], int(p["layer_id"])))
        for i, t in enumerate(self.tracks):
            if i in ignore_tracks or t["net"] == net or int(t["layer_id"]) not in {1, 2, 3, 4, 5, 6, 7, 32} or (layer is not None and int(t["layer_id"]) != layer):
                continue
            distance = segment_segment(a, b, point(t["x1_raw"], t["y1_raw"]), point(t["x2_raw"], t["y2_raw"])) - radius - int(t["width_raw"]) / 20000
            observations.append((distance, "track", str(i), t["net"], int(t["layer_id"])))
        for i, v in enumerate(self.vias):
            if v["net"] == net:
                continue
            distance = point_segment(point(v["x_raw"], v["y_raw"]), a, b) - radius - int(v["size_raw"]) / 20000
            observations.append((distance, "via", str(i), v["net"], 74))
        for r in self.regions:
            flag = 1 if layer is None else 2
            if not r["keepout"] & flag or (layer is not None and r["layer"] not in {layer, 56, 74}) or r["layer"] not in {1, 2, 3, 4, 5, 6, 7, 32, 56, 74}:
                continue
            distance = segment_polygon(a, b, r["vertices"]) - radius
            # Keepout holes are absent in this board's keepouts; refuse an approximation.
            assert not r["holes"]
            observations.append((distance - 2, "keepout", str(r["index"]), "restrictions=" + str(r["keepout"]), r["layer"]))
        return sorted(observations)
