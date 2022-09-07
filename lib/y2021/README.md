# Advent of Code 2021

My Elixir solutions for [Advent of Code 2021](https://adventofcode.com/2021).

**Stars complete: 46/50 :star:**

## Benchmarks

If you're curious how long each of my solutions roughly takes to run.

You can check out the code yourself and run the benchmarks with `mix bench 2021`!

(Benchmarking results sorted manually for ease of read)

```
Name                     ips        average  deviation         median         99th %
day 01, part 1       8072.36       0.124 ms    ±13.98%       0.128 ms       0.154 ms
day 01, part 2       7651.71       0.131 ms    ±20.75%       0.127 ms       0.169 ms
day 02, part 1       2662.64        0.38 ms    ±57.49%        0.36 ms        0.80 ms
day 02, part 2       2540.76        0.39 ms    ±71.13%        0.34 ms        1.85 ms
day 03, part 1       1240.13        0.81 ms    ±27.76%        0.79 ms        1.08 ms
day 03, part 2       1105.95        0.90 ms    ±29.70%        0.86 ms        2.45 ms
day 04, part 1        221.66        4.51 ms    ±14.86%        4.35 ms        7.54 ms
day 04, part 2        115.40        8.67 ms    ±11.94%        8.47 ms       14.60 ms
day 05, part 1         22.63       44.18 ms     ±5.77%       44.88 ms       49.85 ms
day 05, part 2         11.46       87.24 ms     ±7.79%       86.90 ms       97.96 ms
day 06, part 1       8821.81       0.113 ms   ±141.59%      0.0916 ms        0.52 ms
day 06, part 2       5631.11       0.178 ms    ±95.57%       0.159 ms        0.52 ms
day 07, part 1         34.59       28.91 ms     ±5.08%       28.56 ms       38.73 ms
day 07, part 2         27.09       36.92 ms     ±3.62%       36.61 ms       45.85 ms
day 08, part 1        312.55        3.20 ms     ±2.05%        3.19 ms        3.37 ms
day 08, part 2        305.50        3.27 ms     ±8.51%        3.23 ms        3.88 ms
day 09, part 1        148.42        6.74 ms     ±9.83%        6.55 ms        9.83 ms
day 09, part 2         55.80       17.92 ms     ±4.17%       17.74 ms       22.25 ms
day 10, part 1       2735.23        0.37 ms    ±17.55%        0.36 ms        0.51 ms
day 10, part 2       2359.98        0.42 ms    ±65.28%        0.37 ms        1.62 ms
day 11, part 1        171.67        5.83 ms     ±6.66%        5.73 ms        7.82 ms
day 11, part 2         36.04       27.75 ms     ±2.16%       27.64 ms       32.50 ms
day 12, part 1         71.36       14.01 ms    ±10.71%       13.66 ms       20.30 ms
day 12, part 2          0.54     1841.77 ms     ±2.34%     1826.60 ms     1890.38 ms
day 13, part 1       2088.26        0.48 ms     ±4.98%        0.47 ms        0.57 ms
day 13, part 2        696.16        1.44 ms    ±30.74%        1.37 ms        3.02 ms
day 14, part 1       2051.78        0.49 ms     ±7.49%        0.48 ms        0.56 ms
day 14, part 2        525.78        1.90 ms     ±5.15%        1.90 ms        2.28 ms
day 15, part 1          7.53      132.72 ms     ±5.16%      131.81 ms      144.12 ms
day 15, part 2         0.153     6516.40 ms     ±0.00%     6516.40 ms     6516.40 ms
day 16, part 1      10904.45      0.0917 ms   ±104.15%      0.0810 ms        0.24 ms
day 16, part 2      11735.56      0.0852 ms    ±21.39%      0.0813 ms       0.127 ms
day 17, part 1        109.13        9.16 ms     ±2.19%        9.11 ms        9.88 ms
day 17, part 2        109.35        9.14 ms     ±3.31%        9.05 ms       10.40 ms
day 18, part 1        391.85        2.55 ms    ±13.56%        2.50 ms        3.21 ms
day 18, part 2         17.81       56.15 ms    ±27.47%       43.49 ms       75.46 ms
day 20, part 1         29.72       33.64 ms     ±3.34%       33.41 ms       39.49 ms
day 20, part 2          0.58     1718.59 ms     ±0.27%     1720.33 ms     1722.14 ms
day 21, part 1      49240.07      0.0203 ms    ±15.00%      0.0202 ms      0.0209 ms
day 21, part 2        0.0935    10691.71 ms     ±0.00%    10691.71 ms    10691.71 ms
day 22, part 1          1.43      699.75 ms    ±10.29%      705.48 ms      815.63 ms
day 23, part 1          0.93     1077.21 ms     ±1.62%     1080.98 ms     1097.29 ms
day 23, part 2          0.49     2057.30 ms     ±1.87%     2067.28 ms     2089.87 ms
day 24, part 1       0.00584   171194.07 ms     ±0.00%   171194.07 ms   171194.07 ms
day 24, part 2       0.00537   186312.17 ms     ±0.00%   186312.17 ms   186312.17 ms
day 25, part 1        0.0294    33969.58 ms     ±0.00%    33969.58 ms    33969.58 ms
```
