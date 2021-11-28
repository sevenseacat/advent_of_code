# Advent of Code 2015

My Elixir solutions for [Advent of Code 2015](https://adventofcode.com/2015).

## Benchmarks

If you're curious how long each of my solutions roughly takes to run.

You can check out the code yourself and run the benchmarks with `mix bench 2015`!

(Benchmarking results sorted manually for ease of read)

```
Name                     ips        average  deviation         median         99th %
day 01, part 1       6102.05       0.164 ms    ±24.84%       0.160 ms        0.22 ms
day 01, part 2      10491.93      0.0953 ms    ±50.39%      0.0870 ms       0.171 ms
day 02, part 1       1036.33        0.96 ms    ±16.52%        0.92 ms        1.68 ms
day 02, part 2        730.00        1.37 ms     ±6.29%        1.34 ms        1.62 ms
day 03, part 1        264.87        3.78 ms     ±7.43%        3.65 ms        4.56 ms
day 03, part 2        228.66        4.37 ms     ±6.87%        4.39 ms        5.28 ms
day 04, part 1          6.69      149.51 ms     ±1.68%      149.29 ms      156.11 ms
day 04, part 2         0.183     5474.22 ms     ±0.00%     5474.22 ms     5474.22 ms
day 05, part 1        152.80        6.54 ms     ±2.71%        6.53 ms        7.26 ms
day 05, part 2        181.37        5.51 ms    ±15.67%        5.31 ms       11.09 ms
day 06, part 1         0.124     8050.54 ms     ±0.00%     8050.54 ms     8050.54 ms
day 06, part 2         0.129     7761.06 ms     ±0.00%     7761.06 ms     7761.06 ms
day 07, part 1        148.97        6.71 ms     ±1.52%        6.69 ms        7.38 ms
day 07, part 2        148.66        6.73 ms     ±2.29%        6.69 ms        7.52 ms
day 08, part 1        221.20        4.52 ms     ±5.94%        4.46 ms        5.48 ms
day 08, part 2        409.81        2.44 ms     ±4.67%        2.43 ms        2.79 ms
day 09, part 1          5.81      171.99 ms     ±1.55%      171.71 ms      177.09 ms
day 09, part 2          5.81      172.15 ms     ±1.51%      171.34 ms      176.99 ms
day 10, part 1         11.85       84.36 ms     ±5.67%       83.97 ms       98.94 ms
day 10, part 2          0.73     1372.29 ms    ±11.40%     1336.49 ms     1591.93 ms
day 11, part 1        372.14        2.69 ms     ±3.29%        2.67 ms        2.98 ms
day 11, part 2          7.65      130.73 ms     ±0.96%      130.78 ms      135.12 ms
day 12, part 1        203.95        4.90 ms     ±6.61%        4.85 ms        6.51 ms
day 12, part 2        175.92        5.68 ms     ±4.86%        5.64 ms        6.57 ms
day 13, part 1          1.42      704.08 ms     ±2.14%      703.37 ms      733.07 ms
day 13, part 2         0.116     8623.16 ms     ±0.00%     8623.16 ms     8623.16 ms
day 14, part 1       8993.91       0.111 ms    ±31.01%       0.104 ms        0.21 ms
day 14, part 2          9.37      106.77 ms     ±0.83%      106.51 ms      110.59 ms
day 15, part 1         0.110     9066.37 ms     ±0.00%     9066.37 ms     9066.37 ms
day 15, part 2        0.0956    10462.44 ms     ±0.00%    10462.44 ms    10462.44 ms
day 16, part 1        443.97        2.25 ms    ±37.87%        2.15 ms        3.60 ms
day 16, part 2        453.03        2.21 ms     ±7.68%        2.17 ms        2.80 ms
day 17, part 1          0.45     2201.24 ms    ±17.92%     2193.98 ms     2599.33 ms
day 17, part 2          0.45     2214.20 ms    ±17.28%     2230.24 ms     2588.52 ms
day 18, part 1          0.67     1502.58 ms     ±1.69%     1491.55 ms     1540.53 ms
day 18, part 2          0.65     1543.54 ms     ±3.21%     1538.67 ms     1608.66 ms
day 19, part 1         96.26       10.39 ms     ±2.24%       10.32 ms       11.35 ms
day 20, part 1        0.0699    14304.86 ms     ±0.00%    14304.86 ms    14304.86 ms
day 20, part 2        0.0615    16257.06 ms     ±0.00%    16257.06 ms    16257.06 ms
```

(I rushed a lot towards the end of these solutions, and didn't spend any time optimizing them - hence they're comparitively pretty slow. But good enough!)
