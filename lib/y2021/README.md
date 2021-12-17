# Advent of Code 2021

My Elixir solutions for [Advent of Code 2021](https://adventofcode.com/2021).

**Stars complete: 34/34 :star:**

## Benchmarks

If you're curious how long each of my solutions roughly takes to run.

You can check out the code yourself and run the benchmarks with `mix bench 2021`!

(Benchmarking results sorted manually for ease of read)

```
Name                     ips        average  deviation         median         99th %
day 01, part 1       7081.45       0.141 ms    ±12.78%       0.140 ms       0.170 ms
day 01, part 2       5871.28       0.170 ms    ±35.55%       0.160 ms        0.33 ms
day 02, part 1       2466.84        0.41 ms    ±11.81%        0.40 ms        0.47 ms
day 02, part 2       2448.86        0.41 ms     ±6.00%        0.41 ms        0.47 ms
day 03, part 1        922.50        1.08 ms     ±5.71%        1.06 ms        1.19 ms
day 03, part 2        930.52        1.07 ms     ±9.56%        1.06 ms        1.16 ms
day 04, part 1        117.74        8.49 ms     ±2.30%        8.47 ms        9.86 ms
day 04, part 2         59.62       16.77 ms     ±2.41%       16.71 ms       19.34 ms
day 05, part 1         24.64       40.59 ms     ±4.52%       41.01 ms       46.24 ms
day 05, part 2          9.95      100.52 ms     ±3.87%       99.33 ms      114.47 ms
day 06, part 1       7919.65       0.126 ms    ±14.21%       0.124 ms       0.160 ms
day 06, part 2       4317.99        0.23 ms     ±8.75%        0.23 ms        0.27 ms
day 07, part 1         20.23       49.44 ms     ±0.77%       49.32 ms       51.81 ms
day 07, part 2         14.41       69.38 ms     ±0.56%       69.34 ms       70.70 ms
day 08, part 1        238.89        4.19 ms     ±4.46%        4.16 ms        5.52 ms
day 08, part 2        226.42        4.42 ms    ±16.27%        4.23 ms        6.92 ms
day 09, part 1        127.43        7.85 ms     ±7.50%        7.71 ms        9.00 ms
day 09, part 2         46.70       21.41 ms     ±3.27%       21.40 ms       23.91 ms
day 10, part 1       2136.39        0.47 ms     ±8.11%        0.46 ms        0.56 ms
day 10, part 2       2047.54        0.49 ms    ±16.03%        0.48 ms        0.58 ms
day 11, part 1        132.74        7.53 ms     ±2.15%        7.49 ms        8.28 ms
day 11, part 2         27.04       36.98 ms     ±0.44%       36.97 ms       37.42 ms
day 12, part 1         54.63       18.30 ms     ±1.30%       18.17 ms       18.78 ms
day 12, part 2          0.41     2467.15 ms     ±0.71%     2470.08 ms     2483.14 ms
day 13, part 1       1868.47        0.54 ms    ±12.02%        0.53 ms        0.63 ms
day 13, part 2        661.48        1.51 ms     ±5.42%        1.51 ms        1.67 ms
day 14, part 1       1879.21        0.53 ms    ±26.57%        0.50 ms        1.33 ms
day 14, part 2        514.21        1.94 ms     ±6.46%        1.93 ms        2.14 ms
day 15, part 1          6.37      156.88 ms     ±6.65%      155.69 ms      188.99 ms
day 15, part 2         0.132     7552.27 ms     ±0.00%     7552.27 ms     7552.27 ms
day 16, part 1       9320.13       0.107 ms    ±30.66%       0.107 ms       0.155 ms
day 16, part 2       9406.38       0.106 ms    ±32.97%       0.106 ms       0.156 ms
day 17, part 1         20.45       48.90 ms     ±0.61%       48.89 ms       50.83 ms
day 17, part 2         20.47       48.84 ms     ±0.95%       48.77 ms       50.33 ms
```
