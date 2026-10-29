"""Extract final native electrical findings and saved copper allocation."""
import csv,json,re,math,sys,collections
from pathlib import Path
Q=Path(__file__).resolve().parent;R=Q.parent;O=R/'electrical';F=R/'final-validation';sys.path.insert(0,str(O))
from geometry_review import table,point
findings=table(F/'drc-all-findings.tsv');selected=[r for r in findings if r['category']in {'Delay','Matched Lengths','Differential pair coupling'}];groups=collections.defaultdict(list)
for r in selected:groups[r['rule']].append(r)
delay={};values=collections.defaultdict(set);matched=[];uncoupled=[];pairskew=[]
for r in selected:
 s=r['finding'];m=re.search(r'Net (\S+) Actual Propagation Delay = ([\d.]+)ps',s)
 if m:delay[m[1]]=float(m[2]);values[m[1]].add(float(m[2]))
 m=re.search(r'Between Net (\S+) And Net (\S+).*?Delay:([\d.]+)ps.*?Delay:([\d.]+)ps',s)
 if m:matched.append((r,m[1],m[2],float(m[3]),float(m[4])))
 m=re.search(r'Between Net (\S+) And Net (\S+) \[Uncoupled Length = ([\d.]+)mil\], \[Maximum Uncoupled Length = ([\d.]+)mil\]',s)
 if m:uncoupled.append(dict(net_a=m[1],net_b=m[2],uncoupled_mil=float(m[3]),maximum_mil=float(m[4]),excess_mil=float(m[3])-float(m[4]),id=r['id']))
 m=re.search(r'Between Net (\S+) And Net (\S+) Actual Difference.*?is: ([\d.]+)ps, Delay Tolerance : ([\d.]+)ps',s)
 if m:pairskew.append(dict(net_a=m[1],net_b=m[2],difference_ps=float(m[3]),tolerance_ps=float(m[4]),id=r['id']))
unresolved=list(matched)
for _ in range(10):
 pending=[]
 for r,a,b,x,y in unresolved:
  known=delay.get(a);kb=delay.get(b)
  if known is not None and abs(known-x)<.002:assign={a:x,b:y}
  elif known is not None and abs(known-y)<.002:assign={a:y,b:x}
  elif kb is not None and abs(kb-x)<.002:assign={b:x,a:y}
  elif kb is not None and abs(kb-y)<.002:assign={b:y,a:x}
  else:pending.append((r,a,b,x,y));continue
  for n,v in assign.items():delay[n]=v;values[n].add(v)
 if len(pending)==len(unresolved):break
 unresolved=pending
# For isolated groups, the repeated member is the report's upper-delay reference.
for rule,rr in groups.items():
 mm=[z for z in unresolved if z[0]['rule']==rule]
 if not mm:continue
 counter=collections.Counter(n for _,a,b,_,_ in mm for n in(a,b));ref=counter.most_common(1)[0][0]
 for r,a,b,x,y in mm:
  if ref not in(a,b):continue
  other=b if a==ref else a;delay[ref]=y;delay[other]=x;values[ref].add(y);values[other].add(x)
group_summary=[]
for rule,rr in groups.items():
 tol=re.search(r'Delay Tolerance=([\d.]+)ps',rule);ds=[z for z in matched if z[0]['rule']==rule];nums=[v for _,a,b,x,y in ds for v in(x,y)]
 group_summary.append(dict(rule=rule,count=len(rr),tolerance_ps=float(tol[1])if tol else None,reported_min_ps=min(nums)if nums else None,reported_max_ps=max(nums)if nums else None,reported_spread_ps=max(nums)-min(nums)if nums else None,ids=[z['id']for z in rr]))
inventory=F/'post-drc-inventory';tracks=table(inventory/'tracks.tsv');vias=table(inventory/'vias.tsv');nets=table(inventory/'nets.tsv');connections=table(inventory/'connections.tsv');open_counts=collections.Counter(c['net']for c in connections)
ddrnames=sorted({t['net']for t in tracks if t['net'].startswith(('DRAMA_','DRAMB_'))}|{'DRAM_NRESET','DRAM_ZQ0','DRAM_ZQ1','NetR7_2'});allocation=[];signal_debt=collections.defaultdict(lambda:dict(segments=0,length_mil=0,nets=set()));ddr_layer=collections.defaultdict(lambda:dict(segments=0,length_mil=0,nets=set()))
for name in ddrnames:
 tt=[t for t in tracks if t['net']==name];vl=[v for v in vias if v['net']==name];layers=collections.defaultdict(lambda:dict(segments=0,length_mil=0,widths_mil=set()))
 for t in tt:
  layer=int(t['layer_id']);length=math.dist(point(t['x1_raw'],t['y1_raw']),point(t['x2_raw'],t['y2_raw']));layers[layer]['segments']+=1;layers[layer]['length_mil']+=length;layers[layer]['widths_mil'].add(int(t['width_raw'])/10000);ddr_layer[layer]['segments']+=1;ddr_layer[layer]['length_mil']+=length;ddr_layer[layer]['nets'].add(name)
 allocation.append(dict(net=name,remaining_edges=open_counts[name],signal_vias=len(vl),reported_native_delay_ps=sorted(values[name]),copper_length_sum_mil=sum(z['length_mil']for z in layers.values()),layers={str(k):dict(v,widths_mil=sorted(v['widths_mil']))for k,v in layers.items()}))
for t in tracks:
 l=int(t['layer_id']);n=t['net']
 if l not in {2,4,5,6,7}or n in {'GND','VSYS_5V'}or n.startswith(('VDD','NVCC','VDDA','LX')):continue
 z=signal_debt[l];z['segments']+=1;z['length_mil']+=math.dist(point(t['x1_raw'],t['y1_raw']),point(t['x2_raw'],t['y2_raw']));z['nets'].add(n)
serial=lambda d:{str(k):dict(v,nets=sorted(v['nets']))for k,v in d.items()}
out=dict(native_report=str(F/'final-native.drc'),report_utc='2026-10-02 18:37:36 UTC',saved_checkpoint='113',actual_tracks=len(tracks),actual_vias=len(vias),remaining_inventory_edges=len(connections),categories=collections.Counter(r['category']for r in selected),delay_violations=[r for r in selected if r['category']=='Delay'],group_summaries=group_summary,pair_skew_violations=pairskew,uncoupled_violations=uncoupled,differential_width_finding_count=sum('Actual Width' in r['finding']for r in selected if r['category']=='Differential pair coupling'),native_reported_delay_values={n:sorted(v)for n,v in values.items()},ddr_allocation=allocation,ddr_layer_totals=serial(ddr_layer),heuristic_signal_layer_debt=serial(signal_debt),limits=['Reported timing values come from DRC findings, not a full timing export; a missing violation/value is not timing acceptance.','Copper length sum includes branches and stubs, and is not a unique endpoint path length.','Layer debt classifier excludes supply prefixes, GND and VSYS but is not a reviewed net-class enumeration.','Inner impedance/profile/reference validity and fabrication/current acceptance remain unverified.'])
ground=[point(v['x_raw'],v['y_raw'])for v in vias if v['net']=='GND'];returns=[]
for v in vias:
 if not v['net'].startswith(('DRAMA_','DRAMB_')):continue
 p=point(v['x_raw'],v['y_raw']);d=min(math.dist(p,q)for q in ground);returns.append(dict(net=v['net'],point_mil=p,nearest_assigned_ground_via_mil=d))
out['ddr_via_nearest_ground']=returns
thin=[]
for t in tracks:
 if not t['net'].startswith(('VDD','NVCC','VDDA','VSYS'))or int(t['width_raw'])>=50000:continue
 thin.append(dict(net=t['net'],layer=int(t['layer_id']),width_mil=int(t['width_raw'])/10000,length_mil=math.dist(point(t['x1_raw'],t['y1_raw']),point(t['x2_raw'],t['y2_raw'])),primitive=t))
out['power_tracks_below_5mil']=thin
(Q/'final-electrical-findings.json').write_text(json.dumps(out,indent=2))
with (Q/'final-electrical-timing-coupling.tsv').open('w',newline='',encoding='utf-8')as h:
 w=csv.DictWriter(h,fieldnames=['id','category','rule','finding','exact_baseline_match'],delimiter='\t');w.writeheader();w.writerows(selected)
with (Q/'final-ddr-layer-allocation.tsv').open('w',newline='',encoding='utf-8')as h:
 fields=['net','remaining_edges','signal_vias','reported_native_delay_ps','copper_length_sum_mil','layers'];w=csv.DictWriter(h,fieldnames=fields,delimiter='\t');w.writeheader();w.writerows(dict(z,reported_native_delay_ps=json.dumps(z['reported_native_delay_ps']),layers=json.dumps(z['layers']))for z in allocation)
print(json.dumps(dict(categories=out['categories'],groups=[{k:v for k,v in x.items()if k!='ids'}for x in group_summary],uncoupled=len(uncoupled),diffwidth=out['differential_width_finding_count'],ddr_via_over2=[(z['net'],z['signal_vias'])for z in allocation if z['signal_vias']>2],ddr_remaining=[(z['net'],z['remaining_edges'])for z in allocation if z['remaining_edges']],ddr_layers=out['ddr_layer_totals']),indent=2))
