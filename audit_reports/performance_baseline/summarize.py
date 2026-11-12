"""Summarize raw local profile samples without treating rAF gaps as raster timings."""
from pathlib import Path
import json, statistics, math, hashlib
p=Path(__file__).resolve().parent
raw=[json.loads(line) for line in (p/'raw_measurements.jsonl').read_text().splitlines()]
def pct(values,q):
    return sorted(values)[max(0,math.ceil(len(values)*q)-1)] if values else None
summary=[]
for phase in sorted({r['phase'] for r in raw if 'work_us' in r}):
    for size in [100,1000,10000]:
        runs=[r for r in raw if r['phase']==phase and r.get('rows')==size and not r.get('warmup')]
        if not runs:continue
        gaps=[v for r in runs for v in r['frame_gaps_ms']]
        summary.append({'phase':phase,'rows':size,'n':len(runs),'median_work_ms':statistics.median(r['work_us'] for r in runs)/1000,'p95_work_ms':pct([r['work_us'] for r in runs],.95)/1000,'median_through_two_raf_ms':statistics.median(r['through_two_raf_us'] for r in runs)/1000,'p95_raf_gap_ms':pct(gaps,.95),'max_raf_gap_ms':max(gaps) if gaps else None,'raf_gaps_over_16_7_ms':sum(v>16.7 for v in gaps),'raf_gap_count':len(gaps)})
complete=next((r for r in reversed(raw) if r['phase']=='complete'),None)
result={'environment':next((r for r in raw if r['phase']=='environment'),{}),'warmup_samples':[r for r in raw if r.get('warmup')],'summary':summary,'completion':complete,'errors':[r for r in raw if r['phase']=='error'],'limits':['rAF wall-clock gaps are not GPU/raster durations','N=5 warm samples per size; nearest-rank p95 is sample maximum','No forced GC; heap values if available cannot prove retained heap or leaks','Synthetic fixtures and locally preloaded Arial Unicode font; not production-font or backend latency benchmark','Dashboard phase measures model getter work, not full dashboard chart/frame behavior']}
(p/'performance_baseline.json').write_text(json.dumps(result,indent=2,ensure_ascii=False)+'\n')
for r in summary: print(r['phase'],r['rows'],r['n'],round(r['median_work_ms'],3),round(r['median_through_two_raf_ms'],3),r['p95_raf_gap_ms'])
print('complete',bool(complete),'errors',result['errors'])
