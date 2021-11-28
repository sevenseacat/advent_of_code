# Advent of Code 2015

My Elixir solutions for [Advent of Code 2015](https://adventofcode.com/2015).

## Benchmarks

If you're curious how long each of my solutions roughly takes to run.

You can check out the code yourself and run the benchmarks with `mix bench 2015`!

(Benchmarking results sorted manually for ease of read)

```
Name                     ips        average  deviation         median         99th %
day 01, part 1       6176.30       0.162 ms    ±12.55%       0.158 ms        0.21 ms
day 01, part 2       9680.09       0.103 ms    ±40.72%      0.0950 ms       0.184 ms
day 02, part 1       1009.07        0.99 ms     ±8.60%        0.98 ms        1.22 ms
day 02, part 2        665.71        1.50 ms     ±8.30%        1.51 ms        1.81 ms
day 03, part 1        257.12        3.89 ms    ±12.82%        3.70 ms        6.38 ms
day 03, part 2        228.25        4.38 ms     ±8.01%        4.33 ms        5.34 ms
day 04, part 1          5.68      176.18 ms     ±1.90%      176.50 ms      186.15 ms
day 04, part 2         0.155     6461.21 ms     ±0.00%     6461.21 ms     6461.21 ms
day 05, part 1        144.62        6.91 ms     ±2.91%        6.89 ms        7.77 ms
day 05, part 2        180.68        5.53 ms     ±2.15%        5.51 ms        6.20 ms
day 06, part 1         0.126     7908.21 ms     ±0.00%     7908.21 ms     7908.21 ms
day 06, part 2         0.129     7746.81 ms     ±0.00%     7746.81 ms     7746.81 ms
day 07, part 1        146.29        6.84 ms     ±1.95%        6.80 ms        7.52 ms
day 07, part 2        144.75        6.91 ms     ±4.26%        6.83 ms        8.22 ms
day 08, part 1        208.14        4.80 ms     ±5.31%        4.74 ms        5.84 ms
day 08, part 2        364.51        2.74 ms     ±8.56%        2.68 ms        3.58 ms
day 09, part 1          5.69      175.67 ms     ±6.08%      173.38 ms      225.25 ms
day 09, part 2          5.85      171.02 ms     ±1.47%      170.72 ms      177.37 ms
day 10, part 1         11.84       84.42 ms     ±5.56%       84.48 ms       94.48 ms
day 10, part 2          0.72     1391.70 ms     ±9.14%     1379.20 ms     1556.53 ms
day 11, part 1        356.74        2.80 ms    ±10.20%        2.74 ms        4.49 ms
day 11, part 2          7.39      135.26 ms     ±0.95%      135.53 ms      137.36 ms
day 12, part 1        200.59        4.99 ms     ±3.57%        4.97 ms        5.72 ms
day 12, part 2        172.07        5.81 ms     ±6.91%        5.74 ms        7.38 ms
day 13, part 1          1.44      696.72 ms     ±1.07%      694.12 ms      713.85 ms
day 13, part 2         0.117     8562.32 ms     ±0.00%     8562.32 ms     8562.32 ms
day 14, part 1       7776.26       0.129 ms    ±38.16%       0.113 ms        0.32 ms
day 14, part 2          8.76      114.09 ms     ±1.18%      113.85 ms      119.06 ms
day 15, part 1         0.111     9001.84 ms     ±0.00%     9001.84 ms     9001.84 ms
day 15, part 2         0.108     9267.45 ms     ±0.00%     9267.45 ms     9267.45 ms
day 16, part 1        435.83        2.29 ms     ±6.93%        2.27 ms        2.76 ms
day 16, part 2        425.77        2.35 ms    ±15.64%        2.29 ms        3.09 ms
day 17, part 1          0.51     1955.81 ms    ±23.63%     1806.78 ms     2474.16 ms
day 17, part 2          0.45     2228.98 ms    ±16.62%     2221.32 ms     2603.20 ms
day 18, part 1          0.67     1487.94 ms     ±0.78%     1484.19 ms     1504.72 ms
day 18, part 2          0.67     1489.68 ms     ±0.11%     1490.09 ms     1490.99 ms
day 19, part 1         93.54       10.69 ms     ±1.86%       10.65 ms       11.72 ms
```
