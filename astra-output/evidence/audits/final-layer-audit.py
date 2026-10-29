"""Audit copper on dedicated ground and power layers in the saved board."""

import csv
import json
import math
from collections import defaultdict
from pathlib import Path

RUN=Path(__file__).resolve().parents[1]
BASE=RUN/"batches/639-rxd3-complete/after"
OUT=RUN/"quality"
GROUND={2,4,7}
POWER={5,6}
stack=(RUN/"electrical/stack-custom-data.txt").read_text()
for name in ("L2_GND_1","L4_GND_2","L7_GND_3","L5_PWR_1","L6_PWR_2"):
    assert f'Name="{name}"' in stack,name

def read_tsv(path):
    with path.open(newline="") as stream:
        return list(csv.DictReader(stream,delimiter="\t"))

def identity(row):
    endpoints=tuple(sorted(((int(row["x1_raw"]),int(row["y1_raw"])),(int(row["x2_raw"]),int(row["y2_raw"])))))
    return (row["net"],int(row["layer_id"]),int(row["width_raw"]),endpoints)

classes=json.loads((RUN/"electrical/Classes6.json").read_text())
power_class=next(item for item in classes if item.get("NAME")=="POWER" and item.get("KIND")=="0")
power_nets={value for key,value in power_class.items() if key.startswith("M") and key[1:].isdigit()}
rules=json.loads((RUN/"electrical/Rules6.json").read_text())
fifty=next(item for item in rules if item.get("NAME")=="50-OHM SE" and item.get("RULEKIND")=="Width")
assert fifty["ENABLED"]=="TRUE"
assert fifty["SCOPE1EXPRESSION"]=="Not InNetClass('POWER')"
original={identity(row) for row in read_tsv(RUN/"baseline-inventory/tracks.tsv")}
tracks=read_tsv(BASE/"tracks.tsv")
rows=[]
for index,row in enumerate(tracks):
    layer=int(row["layer_id"])
    if layer not in GROUND|POWER:
        continue
    x1,y1,x2,y2=(int(row[field]) for field in ("x1_raw","y1_raw","x2_raw","y2_raw"))
    net=row["net"]
    length=math.hypot(x2-x1,y2-y1)/10000
    layer_role="GND" if layer in GROUND else "PWR"
    provenance="exact_inherited" if identity(row) in original else "not_exact_inherited"
    rule="50-OHM SE" if net not in power_nets else "POWER class excluded from 50-OHM SE"
    ci=net not in power_nets
    rows.append(dict(index=index,layer_id=layer,layer=row["layer"],layer_role=layer_role,net=net,x1_raw=x1,y1_raw=y1,x2_raw=x2,y2_raw=y2,width_raw=int(row["width_raw"]),length_mil=round(length,6),provenance=provenance,power_class=net in power_nets,controlled_impedance_rule_applies=ci,rule=rule))

assert len(rows)==sum(1 for row in tracks if int(row["layer_id"]) in GROUND|POWER)
def write_tsv(path,items,fields):
    with path.open("w",newline="") as stream:
        writer=csv.DictWriter(stream,fieldnames=fields,delimiter="\t",lineterminator="\n")
        writer.writeheader();writer.writerows(items)

write_tsv(OUT/"final-layer-audit-tracks.tsv",rows,list(rows[0]))
agg=defaultdict(list)
for row in rows:
    agg[(row["layer_id"],row["layer"],row["layer_role"],row["net"],row["controlled_impedance_rule_applies"])].append(row)
net_rows=[]
for (layer,layer_name,role,net,ci),items in sorted(agg.items()):
    net_rows.append(dict(layer_id=layer,layer=layer_name,layer_role=role,net=net,controlled_impedance_rule_applies=ci,tracks=len(items),exact_inherited_tracks=sum(item["provenance"]=="exact_inherited" for item in items),not_exact_inherited_tracks=sum(item["provenance"]!="exact_inherited" for item in items),length_mil=round(sum(item["length_mil"] for item in items),6),exact_inherited_length_mil=round(sum(item["length_mil"] for item in items if item["provenance"]=="exact_inherited"),6),not_exact_inherited_length_mil=round(sum(item["length_mil"] for item in items if item["provenance"]!="exact_inherited"),6)))
write_tsv(OUT/"final-layer-audit-nets.tsv",net_rows,list(net_rows[0]))
summary={}
for layer in sorted(GROUND|POWER):
    items=[row for row in rows if row["layer_id"]==layer]
    ci=[row for row in items if row["controlled_impedance_rule_applies"]]
    new=[row for row in items if row["provenance"]!="exact_inherited"]
    summary[str(layer)]=dict(layer=items[0]["layer"] if items else "",role="GND" if layer in GROUND else "PWR",tracks=len(items),nets=len({row["net"] for row in items}),length_mil=round(sum(row["length_mil"] for row in items),6),exact_inherited_tracks=len(items)-len(new),not_exact_inherited_tracks=len(new),exact_inherited_length_mil=round(sum(row["length_mil"] for row in items if row["provenance"]=="exact_inherited"),6),not_exact_inherited_length_mil=round(sum(row["length_mil"] for row in new),6),controlled_impedance_tracks=len(ci),controlled_impedance_nets=len({row["net"] for row in ci}),controlled_impedance_length_mil=round(sum(row["length_mil"] for row in ci),6),controlled_impedance_not_exact_inherited_tracks=sum(row["provenance"]!="exact_inherited" for row in ci))
report=dict(status="read_only_audit",board="batches/639-rxd3-complete/after",track_count=len(tracks),layer_summary=summary,ground_total=dict(tracks=sum(summary[str(layer)]["tracks"] for layer in GROUND),length_mil=round(sum(summary[str(layer)]["length_mil"] for layer in GROUND),6),nets=len({row["net"] for row in rows if row["layer_role"]=="GND"})),ground_signal_total=dict(tracks=sum(summary[str(layer)]["controlled_impedance_tracks"] for layer in GROUND),length_mil=round(sum(summary[str(layer)]["controlled_impedance_length_mil"] for layer in GROUND),6),nets=len({row["net"] for row in rows if row["layer_role"]=="GND" and row["controlled_impedance_rule_applies"]})),power_total=dict(tracks=sum(summary[str(layer)]["tracks"] for layer in POWER),length_mil=round(sum(summary[str(layer)]["length_mil"] for layer in POWER),6),nets=len({row["net"] for row in rows if row["layer_role"]=="PWR"})),power_controlled_impedance_total=dict(tracks=sum(summary[str(layer)]["controlled_impedance_tracks"] for layer in POWER),length_mil=round(sum(summary[str(layer)]["controlled_impedance_length_mil"] for layer in POWER),6),nets=len({row["net"] for row in rows if row["layer_role"]=="PWR" and row["controlled_impedance_rule_applies"]})),classifier=dict(ground_layer_ids=sorted(GROUND),power_layer_ids=sorted(POWER),layer_role_source="electrical/stack-custom-data.txt L2_GND_1, L4_GND_2, L7_GND_3, L5_PWR_1, L6_PWR_2",power_class_source="electrical/Classes6.json POWER KIND=0 members",controlled_impedance_source="electrical/Rules6.json 50-OHM SE enabled Width priority 2 scope Not InNetClass('POWER')",provenance="exact_inherited means identical net, layer, width, and unordered endpoints in baseline-inventory/tracks.tsv; not_exact_inherited can include modified inherited copper and is not proof of wholly new copper"),limits=["Track lengths are summed centerline lengths; overlaps and polygons are not subtracted.","Rule applicability uses net class only; local room and differential-pair width priority are not evaluated per segment.","The audit does not claim that every 50-OHM SE track violates DRC; it identifies controlled-impedance routing on prohibited PWR layers."])
(OUT/"final-layer-audit.json").write_text(json.dumps(report,indent=2)+"\n")
print(json.dumps({"ground_total":report["ground_total"],"power_controlled_impedance_total":report["power_controlled_impedance_total"],"layers":summary}),flush=True)
