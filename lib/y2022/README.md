# Advent of Code 2022

My Elixir solutions for [Advent of Code 2022](https://adventofcode.com/2022).

<!-- stars 2022 start --><img src="https://img.shields.io/badge/2022-45_stars-green?style=for-the-badge" alt="45 stars" /><!-- stars 2022 end -->

## Benchmarks

If you're curious how long each of my solutions roughly takes to run.

You can check out the code yourself and run the benchmarks with `mix bench 2022`!

(Benchmarking results sorted manually for ease of read)

```
Name                     ips        average  deviation         median         99th %
day 01, part 1        4.91 K      203.67 μs    ±13.05%      199.67 μs      250.08 μs
day 01, part 2        4.42 K      226.13 μs    ±17.73%      222.58 μs      275.79 μs
day 02, part 1        2.11 K      474.42 μs    ±40.32%      465.10 μs      613.98 μs
day 02, part 2        2.00 K      499.10 μs    ±54.50%      483.75 μs      638.75 μs
day 03, part 1        1.26 K      793.81 μs     ±3.59%      784.83 μs      860.75 μs
day 03, part 2        1.88 K      530.91 μs    ±45.23%      519.08 μs      626.45 μs
day 04, part 1        0.96 K     1042.70 μs    ±27.94%      970.29 μs     1880.21 μs
day 04, part 2        1.00 K     1004.67 μs    ±10.57%      977.04 μs     1470.99 μs
day 05, part 1        1.62 K      618.88 μs    ±57.29%      550.69 μs     2027.15 μs
day 05, part 2        1.61 K      620.64 μs    ±42.48%      583.29 μs     1476.31 μs
day 06, part 1        1.37 K        0.73 ms    ±22.80%        0.66 ms        1.08 ms
day 06, part 2        0.42 K        2.40 ms     ±8.38%        2.31 ms        2.75 ms
day 07, part 1        1.61 K      622.69 μs     ±6.96%      609.46 μs      713.32 μs
day 07, part 2        1.59 K      627.47 μs     ±7.73%      615.46 μs      716.30 μs
day 08, part 1         40.21       24.87 ms     ±2.39%       24.85 ms       26.44 ms
day 08, part 2         28.77       34.76 ms     ±3.11%       34.65 ms       40.65 ms
day 09, part 1        241.00        4.15 ms    ±43.19%        3.95 ms       14.25 ms
day 09, part 2        197.24        5.07 ms    ±54.01%        4.50 ms       24.35 ms
day 10, part 1       11.53 K       86.71 μs   ±105.73%          79 μs      690.30 μs
day 10, part 2        6.68 K      149.75 μs   ±163.65%      116.15 μs     1148.92 μs
day 11, part 1        2.35 K        0.43 ms     ±8.91%        0.41 ms        0.51 ms
day 11, part 2     0.00475 K      210.69 ms     ±0.32%      210.67 ms      213.19 ms
day 12, part 1         11.25       0.0889 s     ±5.70%       0.0888 s        0.102 s
day 12, part 2         0.160         6.27 s     ±0.00%         6.27 s         6.27 s
day 13, part 1        997.79        1.00 ms     ±7.78%        1.00 ms        1.15 ms
day 13, part 2        840.14        1.19 ms     ±6.67%        1.19 ms        1.36 ms
day 14, part 1         53.03       18.86 ms     ±2.84%       18.72 ms       21.01 ms
day 14, part 2          1.43      700.20 ms     ±1.11%      697.14 ms      718.20 ms
day 15, part 1       10.69 K      0.00009 s    ±25.89%      0.00009 s      0.00014 s
day 15, part 2     0.00026 K         3.88 s     ±0.56%         3.88 s         3.90 s
day 16, part 1         31.71       31.54 ms     ±1.54%       31.54 ms       34.23 ms
day 16, part 2          1.75      570.86 ms    ±13.76%      600.04 ms      667.59 ms
day 17, part 1         39.04       25.62 ms     ±2.97%       25.60 ms       28.49 ms
day 17, part 2         19.43       51.47 ms     ±6.75%       51.30 ms       70.51 ms
day 18, part 1          2.30      434.66 ms     ±1.30%      432.57 ms      448.99 ms
day 18, part 2          1.64      610.84 ms     ±3.29%      613.17 ms      643.32 ms
day 19, part 1         0.160         6.24 s     ±0.00%         6.24 s         6.24 s
day 19, part 2        0.0747        13.39 s     ±0.00%        13.39 s        13.39 s
day 20, part 1          3.08         0.33 s     ±0.95%         0.32 s         0.34 s
day 20, part 2          0.21         4.68 s     ±0.54%         4.68 s         4.70 s
day 21, part 1        429.27        2.33 ms     ±4.16%        2.33 ms        2.43 ms
day 21, part 2        377.25        2.65 ms     ±3.92%        2.63 ms        2.90 ms
day 22, part 1          6.02      166.18 ms     ±7.96%      163.94 ms      198.08 ms
day 22, part 1          6.10      163.93 ms     ±6.02%      164.29 ms      184.92 ms
day 22, part 2          8.47      118.05 ms     ±7.88%      114.27 ms      146.67 ms
```
