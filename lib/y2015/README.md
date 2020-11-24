# Advent of Code 2015

My Elixir solutions for [Advent of Code 2015](https://adventofcode.com/2015).

## Benchmarks

If you're curious how long each of my solutions roughly takes to run.

You can check out the code yourself and run the benchmarks with `mix bench 2015`!

(Benchmarking results sorted manually for ease of read)

```
Name                     ips        average  deviation         median         99th %
day 01, part 1       6343.89       0.158 ms    ±19.77%       0.156 ms        0.20 ms
day 01, part 2      10912.55      0.0916 ms    ±43.50%      0.0870 ms       0.160 ms
day 02, part 1       1080.66        0.93 ms     ±7.24%        0.91 ms        1.13 ms
day 02, part 2        738.32        1.35 ms     ±6.30%        1.33 ms        1.63 ms
day 03, part 1        262.09        3.82 ms     ±8.22%        3.68 ms        4.76 ms
day 03, part 2        228.58        4.37 ms     ±8.36%        4.31 ms        5.42 ms
day 04, part 1          6.96      143.63 ms     ±1.02%      143.35 ms      147.79 ms
day 04, part 2         0.190     5259.47 ms     ±0.00%     5259.47 ms     5259.47 ms
day 05, part 1        151.25        6.61 ms     ±5.01%        6.56 ms        7.73 ms
day 05, part 2        187.19        5.34 ms     ±2.27%        5.32 ms        6.05 ms
day 06, part 1         0.124     8043.46 ms     ±0.00%     8043.46 ms     8043.46 ms
day 06, part 2         0.129     7743.32 ms     ±0.00%     7743.32 ms     7743.32 ms
day 07, part 1        148.06        6.75 ms     ±3.92%        6.68 ms        7.82 ms
day 07, part 2        149.55        6.69 ms     ±2.10%        6.65 ms        7.37 ms
day 08, part 1        208.46        4.80 ms    ±13.29%        4.62 ms        7.97 ms
day 08, part 2        391.40        2.55 ms     ±4.69%        2.54 ms        3.00 ms
day 09, part 1          5.86      170.74 ms     ±1.50%      170.23 ms      178.67 ms
day 09, part 2          5.85      171.04 ms     ±1.14%      171.13 ms      175.42 ms
day 10, part 1         11.83       84.55 ms     ±5.94%       84.21 ms      100.67 ms
day 10, part 2          0.72     1390.55 ms     ±9.20%     1380.70 ms     1555.78 ms
day 11, part 1        364.50        2.74 ms     ±2.27%        2.72 ms        2.97 ms
day 11, part 2          7.48      133.70 ms     ±0.71%      133.86 ms      135.81 ms
day 12, part 1        204.70        4.89 ms     ±7.64%        4.84 ms        5.96 ms
day 12, part 2        175.84        5.69 ms     ±4.18%        5.65 ms        6.40 ms
day 13, part 1          1.44      696.17 ms     ±0.61%      695.05 ms      705.55 ms
day 13, part 2         0.117     8573.60 ms     ±0.00%     8573.60 ms     8573.60 ms
day 14, part 1       8802.89       0.114 ms    ±19.22%       0.108 ms        0.20 ms
day 14, part 2          9.31      107.38 ms     ±2.73%      106.50 ms      121.28 ms
day 15, part 1         0.109     9209.12 ms     ±0.00%     9209.12 ms     9209.12 ms
day 15, part 2         0.108     9300.34 ms     ±0.00%     9300.34 ms     9300.34 ms
day 16, part 1        459.67        2.18 ms    ±10.03%        2.15 ms        2.82 ms
day 16, part 2        449.55        2.22 ms    ±12.28%        2.19 ms        2.70 ms
day 17, part 1          0.52     1934.63 ms    ±23.67%     1806.83 ms     2442.84 ms
day 17, part 2          0.45     2229.67 ms    ±18.12%     2252.80 ms     2621.71 ms
```
