#! /usr/bin/env python3

import sys
import pandas as pd
import numpy as np
from scipy import stats

df = pd.read_csv(sys.stdin, names=['our', 'ref'], header=None)
if len(df.columns) != 2:
    raise ValueError("CSV file must contain exactly two columns")

stats = pd.DataFrame({
    'our': [
        df['our'].mean(),
        df['our'].std(),
        df['our'].median(),
        df['our'].min(),
        df['our'].max()
        ],
    'ref': [
        df['ref'].mean(),
        df['ref'].std(),
        df['ref'].median(),
        df['ref'].min(),
        df['ref'].max()
        ]
    }, index=['mean', 'stdev', 'median', 'min', 'max'])

print("Summary statistics:")
print(stats)
delta_mean = stats['our']['mean'] - stats['ref']['mean']
min_stdev = min(stats['our']['stdev'], stats['ref']['stdev'])
# check if the variation within each implementation is larger than the difference between their means
if delta_mean < 2*min_stdev:
    print("Success: both implementations are identical with probability > 95%")
else:
    print("Error: large deviation between our and the HPCC implementations")

