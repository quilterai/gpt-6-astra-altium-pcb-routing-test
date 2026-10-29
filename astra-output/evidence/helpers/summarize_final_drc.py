"""Preserve every final DRC finding and compare exact occurrences with baseline."""

import argparse
import csv
import json
from collections import Counter
from pathlib import Path

from compare_routing import delta, read_drc


def category(rule):
    """Group native rule sections without discarding their full scope text."""
    prefixes = [
        ('Clearance Constraint', 'Clearance'), ('Short-Circuit', 'Short-Circuit'),
        ('Un-Routed', 'Un-Routed Net'), ('Width Constraint', 'Width'),
        ('Differential Pairs', 'Differential pair coupling'),
        ('Hole Size', 'Hole Size'), ('Hole To Hole', 'Hole To Hole Clearance'),
        ('Minimum Solder', 'Minimum Solder Mask Sliver'),
        ('Silk To Solder', 'Silk To Solder Mask'), ('Silk to Silk', 'Silk To Silk'),
        ('Net Antennae', 'Net Antennae'), ('Board Clearance', 'Board Clearance'),
        ('Board Outline', 'Board Outline Clearance'), ('Delay Constraint', 'Delay'),
        ('Matched', 'Matched Lengths'), ('Room ', 'Room Definition'),
        ('Component Clearance', 'Component Clearance'),
    ]
    return next((name for prefix, name in prefixes if rule.startswith(prefix)), rule)


def write_tsv(path, rows, fields):
    """Write stable tab-separated records with a header."""
    with path.open('w', newline='', encoding='utf-8') as stream:
        writer = csv.DictWriter(stream, fieldnames=fields, delimiter='\t')
        writer.writeheader()
        writer.writerows(rows)


def main():
    """Generate exact ledgers, category totals, and a complete Markdown appendix."""
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('baseline', type=Path)
    parser.add_argument('final', type=Path)
    parser.add_argument('output', type=Path)
    args = parser.parse_args()
    baseline, final = read_drc(args.baseline), read_drc(args.final)
    args.output.mkdir(parents=True, exist_ok=True)
    changes = delta(baseline['findings'], final['findings'])
    totals = {}
    for label, report in [('baseline', baseline), ('final', final)]:
        counts = Counter()
        for section in report['sections']:
            counts[category(section['rule'])] += section['count']
        totals[label] = counts
    for label in ('added', 'removed'):
        counts = Counter()
        for entry in changes[label]:
            counts[category(entry['record']['rule'])] += entry['count']
        totals[label] = counts
    categories = sorted(set().union(*(set(value) for value in totals.values())))
    summary_rows = [dict(category=name, **{label: values[name] for label, values in totals.items()}) for name in categories]
    write_tsv(args.output / 'drc-category-summary.tsv', summary_rows, ['category', 'baseline', 'final', 'added', 'removed'])
    for label in ('added', 'removed'):
        rows = [dict(category=category(entry['record']['rule']), **entry['record'], occurrences=entry['count']) for entry in changes[label]]
        write_tsv(args.output / f'drc-{label}-findings.tsv', rows, ['category', 'rule', 'finding', 'occurrences'])
    ledger = []
    for key, count in final['findings'].items():
        entry = dict(key)
        retained = min(count, baseline['findings'][key])
        for index in range(count):
            ledger.append(dict(id=f'DRC-{len(ledger)+1:04d}', category=category(entry['rule']), **entry, exact_baseline_match=index < retained))
    assert len(ledger) == final['total']
    write_tsv(args.output / 'drc-all-findings.tsv', ledger, ['id', 'category', 'rule', 'finding', 'exact_baseline_match'])
    summary = dict(
        baseline={key: value for key, value in baseline.items() if key != 'findings'},
        final={key: value for key, value in final.items() if key != 'findings'},
        exact_changes=changes,
        processed_rules_added=sorted({s['rule'] for s in final['sections']} - {s['rule'] for s in baseline['sections']}),
        processed_rules_removed=sorted({s['rule'] for s in baseline['sections']} - {s['rule'] for s in final['sections']}),
        categories=summary_rows,
    )
    (args.output / 'drc-summary.json').write_text(json.dumps(summary, indent=2), encoding='utf-8')
    lines = ['# Complete final native DRC ledger', '',
             f"Native report: {final['metadata']['Date']} {final['metadata']['Time']}; {final['total']:,} findings; {final['waived']} waived.", '',
             'Each native occurrence has its own ID. An exact baseline match means the complete rule and finding text already occurred in the baseline report. A changed string is not proof that a physical defect is new.', '',
             '| Category | Baseline | Final | Added exact occurrences | Removed exact occurrences |',
             '|---|---:|---:|---:|---:|']
    for row in summary_rows:
        lines.append(f"| {row['category']} | {row['baseline']} | {row['final']} | {row['added']} | {row['removed']} |")
    for section in final['sections']:
        lines.extend(['', '## ' + section['rule'], '', f"Native subtotal: {section['count']}.", ''])
        for row in ledger:
            if row['rule'] == section['rule']:
                source = 'exact baseline match' if row['exact_baseline_match'] else 'absent from baseline exact text'
                lines.extend([f"### {row['id']} ({source})", '', row['finding'], ''])
    (args.output / 'DRC_APPENDIX.md').write_text('\n'.join(lines), encoding='utf-8')
    print(json.dumps(dict(baseline_total=baseline['total'], final_total=final['total'], added=changes['added_count'], removed=changes['removed_count'], categories=summary_rows), indent=2))


if __name__ == '__main__':
    main()
