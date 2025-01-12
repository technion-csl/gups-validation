# gups-validation
This repo validates our implementation of the GUPS benchmark against the official HPCC code.

# How to build and run
Simply invoke `make` and it will build our gups executable and hpcc, run them 30 times, and compare the results.

The output on a Sandybridge CPU is (the reported numbers are performance in units of giga updates per second):

```
Summary statistics:
             our       ref
mean    0.029247  0.029219
stdev   0.000015  0.000024
median  0.029248  0.029230
min     0.029189  0.029168
max     0.029267  0.029244
Success: both implementations are identical with probability > 95%
```

