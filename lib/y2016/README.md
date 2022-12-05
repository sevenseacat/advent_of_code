# Advent of Code 2016

My Elixir solutions for [Advent of Code 2016](https://adventofcode.com/2016).

<!-- stars 2016 start --><img src="https://img.shields.io/badge/2016-%E2%AD%90%EF%B8%8F_50_stars_%E2%AD%90%EF%B8%8F-brightgreen?style=for-the-badge" alt="50 stars" /><!-- stars 2016 end -->

## Benchmarks

If you're curious how long each of my solutions roughly takes to run.

You can check out the code yourself and run the benchmarks with `mix bench 2016`!

(Benchmarking results sorted manually for ease of read)

```
Name                     ips        average  deviation         median         99th %
day 01, part 1      14383.07      0.0695 ms    ±30.99%      0.0657 ms       0.107 ms
day 01, part 2       6301.18       0.159 ms    ±10.50%       0.156 ms        0.21 ms
day 02, part 1        643.27        1.55 ms     ±2.80%        1.55 ms        1.69 ms
day 02, part 2        369.57        2.71 ms    ±12.19%        2.64 ms        4.14 ms
day 03, part 1       2036.93        0.49 ms    ±10.99%        0.48 ms        0.64 ms
day 03, part 2       1933.02        0.52 ms     ±8.22%        0.50 ms        0.62 ms
day 04, part 1        174.21        5.74 ms     ±2.88%        5.72 ms        6.00 ms
day 04, part 2        184.91        5.41 ms     ±6.52%        5.45 ms        6.19 ms
day 05, part 1          0.22     4640.91 ms     ±0.52%     4640.91 ms     4657.91 ms
day 05, part 2         0.149     6729.63 ms     ±0.00%     6729.63 ms     6729.63 ms
day 06, part 1        622.11        1.61 ms     ±6.16%        1.59 ms        1.88 ms
day 06, part 2        621.16        1.61 ms     ±3.87%        1.60 ms        1.85 ms
day 07, part 1         52.02       19.22 ms     ±5.47%       19.08 ms       28.18 ms
day 07, part 2         70.70       14.14 ms     ±0.86%       14.15 ms       14.57 ms
day 08, part 1        432.01        2.31 ms     ±6.74%        2.29 ms        3.53 ms
day 09, part 1        223.46        4.48 ms     ±8.41%        4.38 ms        5.58 ms
day 09, part 2        215.44        4.64 ms     ±2.94%        4.61 ms        5.03 ms
day 10, part 1        484.79        2.06 ms     ±5.93%        2.05 ms        2.86 ms
day 10, part 2        461.71        2.17 ms    ±11.97%        2.10 ms        3.24 ms
day 11, part 1         12.44       80.40 ms     ±0.70%       80.52 ms       81.55 ms
day 11, part 2          1.87      533.46 ms     ±0.20%      533.16 ms      536.13 ms
day 12, part 1         15.13       66.09 ms     ±2.16%       65.84 ms       77.05 ms
day 12, part 2          0.53     1898.66 ms     ±0.39%     1894.63 ms     1907.16 ms
day 13, part 1       3763.49        0.27 ms     ±6.24%        0.26 ms        0.34 ms
day 14, part 1          0.40     2530.23 ms     ±0.11%     2530.23 ms     2532.19 ms
day 14, part 2        0.0448    22314.42 ms     ±0.00%    22314.42 ms    22314.42 ms
day 15, part 1        464.37        2.15 ms     ±3.39%        2.15 ms        2.56 ms
day 15, part 2          1.77      564.09 ms     ±2.05%      554.95 ms      581.05 ms
day 16, part 1     138580.84     0.00722 ms   ±180.60%     0.00675 ms      0.0219 ms
day 16, part 2          0.55     1817.81 ms     ±8.68%     1889.19 ms     1927.35 ms
day 17, part 1      16426.28      0.0609 ms    ±10.67%      0.0597 ms      0.0720 ms
day 17, part 2          1.74      573.14 ms     ±0.12%      572.86 ms      574.56 ms
day 18, part 1       1928.36        0.52 ms    ±12.95%        0.50 ms        0.64 ms
day 18, part 2          0.30     3290.21 ms     ±2.65%     3290.21 ms     3351.78 ms
day 19, part 1         11.46       87.28 ms    ±21.65%       85.77 ms      183.46 ms
day 19, part 2    4112587.66     0.00024 ms  ±4079.84%     0.00025 ms     0.00038 ms
day 20, part 1       2406.76        0.42 ms    ±23.19%        0.41 ms        0.54 ms
day 20, part 2       1880.72        0.53 ms     ±7.62%        0.52 ms        0.63 ms
day 21, part 1      10452.99      0.0957 ms    ±72.83%      0.0758 ms       0.192 ms
day 21, part 2      11103.77      0.0901 ms    ±24.83%      0.0838 ms       0.165 ms
day 22, part 1         20.38       49.07 ms     ±1.95%       49.35 ms       51.57 ms
day 22, part 2          3.42      291.99 ms     ±4.73%      287.93 ms      324.14 ms
day 23, part 1        160.57        6.23 ms     ±8.68%        6.12 ms        8.24 ms
day 23, part 2       0.00294   340251.62 ms     ±0.00%   340251.62 ms   340251.62 ms
day 24, part 1          2.15      464.66 ms     ±2.82%      458.10 ms      499.50 ms
day 24, part 2          1.93      518.02 ms     ±1.79%      518.46 ms      533.83 ms
day 25, part 1          1.31      764.07 ms     ±0.42%      763.03 ms      769.82 ms
```
