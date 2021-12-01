# Advent of Code 2015

My Elixir solutions for [Advent of Code 2015](https://adventofcode.com/2015).

**Stars complete: 48/50 :star:**

(The only puzzle I haven't completed is day 19, part 2)

## Benchmarks

If you're curious how long each of my solutions roughly takes to run.

You can check out the code yourself and run the benchmarks with `mix bench 2015`!

(Benchmarking results sorted manually for ease of read)

```
Name                     ips        average  deviation         median         99th %
day 01, part 1       6544.88       0.153 ms     ±9.11%       0.152 ms       0.191 ms
day 01, part 2      11436.12      0.0874 ms    ±41.82%      0.0830 ms       0.150 ms
day 02, part 1       1048.57        0.95 ms     ±9.16%        0.93 ms        1.24 ms
day 02, part 2        682.52        1.47 ms     ±8.26%        1.42 ms        1.76 ms
day 03, part 1        262.91        3.80 ms     ±8.41%        3.66 ms        4.74 ms
day 03, part 2        231.44        4.32 ms     ±8.90%        4.26 ms        5.54 ms
day 04, part 1          7.67      130.45 ms     ±1.98%      129.53 ms      141.03 ms
day 04, part 2          0.21     4681.81 ms     ±0.23%     4681.81 ms     4689.52 ms
day 05, part 1        148.61        6.73 ms     ±2.67%        6.70 ms        7.51 ms
day 05, part 2        188.15        5.31 ms     ±2.46%        5.29 ms        6.00 ms
day 06, part 1         0.124     8076.22 ms     ±0.00%     8076.22 ms     8076.22 ms
day 06, part 2         0.129     7764.37 ms     ±0.00%     7764.37 ms     7764.37 ms
day 07, part 1        146.26        6.84 ms     ±1.91%        6.80 ms        7.52 ms
day 07, part 2        146.80        6.81 ms     ±1.76%        6.78 ms        7.46 ms
day 08, part 1        215.38        4.64 ms     ±3.93%        4.58 ms        5.50 ms
day 08, part 2        403.59        2.48 ms     ±6.79%        2.44 ms        3.08 ms
day 09, part 1          5.56      179.81 ms     ±9.11%      173.25 ms      245.68 ms
day 09, part 2          5.79      172.65 ms     ±1.49%      172.54 ms      180.28 ms
day 10, part 1         12.29       81.35 ms     ±6.42%       81.40 ms       92.55 ms
day 10, part 2          0.75     1335.45 ms     ±9.77%     1320.61 ms     1506.73 ms
day 11, part 1        378.47        2.64 ms     ±2.52%        2.62 ms        2.88 ms
day 11, part 2          7.81      127.98 ms     ±1.14%      127.52 ms      131.85 ms
day 12, part 1        209.04        4.78 ms     ±3.87%        4.76 ms        5.57 ms
day 12, part 2        178.62        5.60 ms     ±5.76%        5.56 ms        6.46 ms
day 13, part 1          1.40      715.20 ms     ±0.58%      715.92 ms      721.71 ms
day 13, part 2         0.114     8797.36 ms     ±0.00%     8797.36 ms     8797.36 ms
day 14, part 1       8997.25       0.111 ms    ±20.15%       0.106 ms        0.21 ms
day 14, part 2          9.30      107.57 ms     ±1.13%      107.26 ms      111.13 ms
day 15, part 1         0.111     9041.42 ms     ±0.00%     9041.42 ms     9041.42 ms
day 15, part 2         0.108     9293.34 ms     ±0.00%     9293.34 ms     9293.34 ms
day 16, part 1        476.94        2.10 ms     ±6.18%        2.06 ms        2.47 ms
day 16, part 2        458.62        2.18 ms     ±7.38%        2.14 ms        2.55 ms
day 17, part 1          0.51     1963.01 ms    ±22.59%     1815.61 ms     2461.46 ms
day 17, part 2          0.45     2238.36 ms    ±18.07%     2240.97 ms     2641.50 ms
day 18, part 1          0.66     1518.05 ms     ±0.21%     1518.58 ms     1520.96 ms
day 18, part 2          0.66     1522.20 ms     ±0.32%     1521.18 ms     1528.85 ms
day 19, part 1         98.35       10.17 ms     ±2.27%       10.10 ms       11.38 ms
day 20, part 1         0.101     9895.44 ms     ±0.00%     9895.44 ms     9895.44 ms
day 20, part 2        0.0892    11217.01 ms     ±0.00%    11217.01 ms    11217.01 ms
day 21, part 1       1725.72        0.58 ms    ±11.72%        0.55 ms        0.80 ms
day 21, part 2        857.92        1.17 ms     ±6.07%        1.13 ms        1.38 ms
day 22, part 1          0.48     2102.88 ms     ±0.53%     2097.38 ms     2115.65 ms
day 22, part 2          0.25     3995.35 ms     ±0.18%     3995.35 ms     4000.54 ms
day 23, part 1       2392.75        0.42 ms     ±6.34%        0.42 ms        0.50 ms
day 23, part 2       2087.65        0.48 ms     ±6.10%        0.48 ms        0.57 ms
day 24, part 1          2.72      367.44 ms    ±10.51%      352.85 ms      459.08 ms
day 24, part 2        134.65        7.43 ms    ±11.99%        7.58 ms        9.74 ms
day 25, part 1          2.96      337.31 ms     ±0.27%      337.07 ms      339.45 ms
```
