# Advent of Code 2024

My Elixir solutions for [Advent of Code 2024](https://adventofcode.com/2024).

<!-- stars 2024 start --><img src="https://img.shields.io/static/v1?label=2024&message=42%20stars&style=for-the-badge&color=green" alt="42 stars" /><!-- stars 2024 end -->

## Benchmarks

If you're curious how long each of my solutions roughly takes to run.

You can check out the code yourself and run the benchmarks with `mix bench 2024`!

(Benchmarking results sorted manually for ease of read)

```
Name                     ips        average  deviation         median         99th %
day 01, part 1       1637.35        0.61 ms     ±4.85%        0.61 ms        0.69 ms
day 01, part 2       1602.76        0.62 ms     ±4.39%        0.62 ms        0.70 ms
day 02, part 1       2187.30        0.46 ms     ±5.13%        0.45 ms        0.53 ms
day 02, part 2       1387.04        0.72 ms     ±4.76%        0.71 ms        0.81 ms
day 03, part 1       1875.18        0.53 ms     ±4.96%        0.53 ms        0.60 ms
day 03, part 2       1018.10        0.98 ms     ±2.97%        0.97 ms        1.07 ms
day 04, part 1        108.30        9.23 ms     ±3.71%        9.07 ms       10.17 ms
day 04, part 2        119.67        8.36 ms     ±4.63%        8.10 ms        9.17 ms
day 05, part 1        994.47        1.01 ms     ±3.03%        1.00 ms        1.10 ms
day 05, part 2        134.09        7.46 ms     ±2.85%        7.45 ms        8.04 ms
day 06, part 1        141.86        7.05 ms     ±6.65%        7.13 ms        8.17 ms
day 06, part 2          1.13      881.80 ms     ±0.33%      882.04 ms      885.71 ms
day 07, part 1        102.28        9.78 ms     ±2.20%        9.77 ms       10.33 ms
day 07, part 2         14.56       68.66 ms     ±0.66%       68.75 ms       69.78 ms
day 08, part 1       1060.88        0.94 ms     ±6.65%        0.92 ms        1.08 ms
day 08, part 2        827.26        1.21 ms     ±7.61%        1.18 ms        1.39 ms
day 09, part 1          9.33      107.22 ms     ±0.49%      107.06 ms      108.74 ms
day 09, part 2          7.68      130.17 ms     ±0.93%      130.17 ms      132.76 ms
day 10, part 1          3.87      258.13 ms     ±0.90%      258.51 ms      263.14 ms
day 10, part 2          4.19      238.57 ms     ±0.55%      238.51 ms      241.13 ms
day 11, part 1        838.21        1.19 ms     ±4.86%        1.21 ms        1.29 ms
day 11, part 2         19.52       51.22 ms     ±1.86%       51.26 ms       53.37 ms
day 12, part 1          7.16      139.70 ms     ±1.82%      139.22 ms      144.95 ms
day 12, part 2          6.84      146.22 ms     ±1.32%      145.82 ms      151.25 ms
day 13, part 2       1298.79        0.77 ms     ±3.47%        0.76 ms        0.85 ms
day 13, part 1       1294.57        0.77 ms     ±4.01%        0.76 ms        0.86 ms
day 14, part 1        516.12        1.94 ms     ±8.66%        1.85 ms        2.30 ms
day 14, part 2          1.41      707.27 ms     ±0.37%      707.76 ms      710.36 ms
day 15, part 1          5.06      197.80 ms     ±0.60%      197.59 ms      201.50 ms
day 16, part 1         12.91       77.43 ms     ±5.49%       77.14 ms       86.71 ms
day 16, part 2         13.07       76.51 ms     ±5.00%       76.09 ms       85.69 ms
day 17, part 1       45.64 K       21.91 μs    ±15.81%       21.17 μs       37.50 μs
day 18, part 1         22.53       44.38 ms     ±5.11%       44.48 ms       48.54 ms
day 18, part 2          4.04      247.58 ms     ±3.18%      247.68 ms      260.90 ms
day 19, part 1         29.38       34.03 ms     ±0.86%       34.01 ms       35.47 ms
day 19, part 2         29.36       34.06 ms     ±1.18%       34.03 ms       36.73 ms
day 20, part 1         13.45       74.33 ms     ±6.84%       74.14 ms       83.83 ms
day 20, part 2          1.30      771.43 ms     ±1.61%      767.13 ms      796.90 ms
day 22, part 1         20.83       48.01 ms     ±0.83%       47.98 ms       49.13 ms
day 22, part 2        0.0223        44.87 s     ±0.00%        44.87 s        44.87 s
day 23, part 2         12.25       81.65 ms     ±0.49%       81.61 ms       82.64 ms
day 23, part 1         11.91       83.99 ms     ±0.72%       83.86 ms       86.70 ms
```
