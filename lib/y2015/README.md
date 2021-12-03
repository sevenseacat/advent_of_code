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
day 01, part 1       3358.01        0.30 ms    ±35.70%        0.29 ms        0.53 ms
day 01, part 2       5261.18       0.190 ms    ±31.35%       0.177 ms        0.29 ms
day 02, part 1       1682.59        0.59 ms    ±13.17%        0.58 ms        0.88 ms
day 02, part 2        995.41        1.00 ms     ±6.52%        1.00 ms        1.19 ms
day 03, part 1        393.12        2.54 ms     ±4.58%        2.51 ms        2.90 ms
day 03, part 2        342.62        2.92 ms     ±4.89%        2.89 ms        3.41 ms
day 04, part 1         12.11       82.60 ms     ±2.86%       82.29 ms       88.93 ms
day 04, part 2          0.34     2942.59 ms     ±0.61%     2944.13 ms     2958.98 ms
day 05, part 1        248.84        4.02 ms     ±7.27%        3.95 ms        5.43 ms
day 05, part 2        377.28        2.65 ms     ±3.12%        2.64 ms        2.93 ms
day 06, part 1         0.190     5264.83 ms     ±0.49%     5264.83 ms     5283.16 ms
day 06, part 2         0.196     5115.09 ms     ±0.14%     5115.09 ms     5120.12 ms
day 07, part 1        171.91        5.82 ms    ±26.36%        5.51 ms       15.35 ms
day 07, part 2        153.08        6.53 ms    ±16.64%        5.93 ms        8.45 ms
day 08, part 1        358.83        2.79 ms     ±7.27%        2.75 ms        4.22 ms
day 08, part 2        500.50        2.00 ms    ±22.77%        1.88 ms        4.03 ms
day 09, part 1          7.19      139.11 ms     ±5.10%      136.12 ms      156.55 ms
day 09, part 2          7.33      136.38 ms     ±3.43%      135.69 ms      154.68 ms
day 10, part 1         18.85       53.06 ms     ±4.80%       52.74 ms       66.32 ms
day 10, part 2          1.26      795.63 ms     ±4.60%      800.85 ms      847.92 ms
day 11, part 1        246.05        4.06 ms     ±9.24%        3.95 ms        6.09 ms
day 11, part 2          5.30      188.82 ms     ±0.22%      188.67 ms      189.70 ms
day 12, part 1        385.07        2.60 ms    ±25.09%        2.53 ms        3.66 ms
day 12, part 2        226.92        4.41 ms    ±22.71%        3.98 ms        6.75 ms
day 13, part 1          1.73      576.89 ms     ±0.41%      576.41 ms      582.83 ms
day 13, part 2         0.147     6789.08 ms     ±0.04%     6789.08 ms     6790.99 ms
day 14, part 1       6861.00       0.146 ms    ±34.31%       0.143 ms        0.27 ms
day 14, part 2         15.23       65.65 ms     ±1.42%       65.62 ms       67.96 ms
day 15, part 1         0.182     5506.44 ms     ±0.03%     5506.44 ms     5507.70 ms
day 15, part 2         0.188     5330.04 ms     ±0.11%     5330.04 ms     5334.01 ms
day 16, part 1        780.62        1.28 ms    ±14.13%        1.24 ms        2.53 ms
day 16, part 2        757.00        1.32 ms    ±15.68%        1.27 ms        2.61 ms
day 17, part 1          0.61     1645.27 ms     ±5.89%     1642.87 ms     1774.56 ms
day 17, part 2          0.65     1530.06 ms     ±6.42%     1560.83 ms     1618.49 ms
day 18, part 1          0.86     1156.44 ms     ±3.28%     1137.39 ms     1205.20 ms
day 18, part 2          0.88     1141.68 ms     ±1.27%     1138.42 ms     1163.90 ms
day 19, part 1        178.30        5.61 ms     ±4.10%        5.56 ms        6.48 ms
day 20, part 1         0.137     7300.17 ms     ±0.25%     7300.17 ms     7313.01 ms
day 20, part 2         0.119     8408.06 ms     ±0.34%     8408.06 ms     8428.43 ms
day 21, part 1       2025.25        0.49 ms     ±6.69%        0.48 ms        0.60 ms
day 21, part 2        993.16        1.01 ms     ±2.40%        1.00 ms        1.09 ms
day 22, part 1          3.06      327.17 ms     ±0.75%      326.51 ms      336.33 ms
day 22, part 2          1.63      613.54 ms     ±0.25%      612.80 ms      616.20 ms
day 23, part 1       2372.29        0.42 ms    ±68.44%        0.39 ms        1.02 ms
day 23, part 2       2143.26        0.47 ms     ±9.14%        0.46 ms        0.57 ms
day 24, part 1          5.33      187.65 ms    ±13.97%      183.90 ms      290.47 ms
day 24, part 2        188.46        5.31 ms     ±6.27%        5.26 ms        6.09 ms
day 25, part 1          5.44      183.98 ms     ±0.37%      184.00 ms      185.48 ms
```
