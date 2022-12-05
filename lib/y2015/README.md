# Advent of Code 2015

My Elixir solutions for [Advent of Code 2015](https://adventofcode.com/2015).

<!-- stars 2015 start --><img src="https://img.shields.io/badge/2015-%E2%AD%90%EF%B8%8F_50_stars_%E2%AD%90%EF%B8%8F-brightgreen?style=for-the-badge" alt="50 stars" /><!-- stars 2015 end -->

## Benchmarks

If you're curious how long each of my solutions roughly takes to run.

You can check out the code yourself and run the benchmarks with `mix bench 2015`!

(Benchmarking results sorted manually for ease of read)

```
Name                     ips        average  deviation         median         99th %
day 01, part 1       6159.45       0.162 ms    ±41.71%       0.162 ms       0.169 ms
day 01, part 2      11450.66      0.0873 ms    ±65.09%      0.0807 ms       0.132 ms
day 02, part 1       2675.34        0.37 ms    ±55.02%        0.36 ms        0.43 ms
day 02, part 2       1818.70        0.55 ms     ±7.64%        0.54 ms        0.66 ms
day 03, part 1        402.28        2.49 ms     ±3.34%        2.48 ms        2.66 ms
day 03, part 2        377.93        2.65 ms     ±7.55%        2.61 ms        3.45 ms
day 04, part 1         12.59       79.40 ms     ±0.41%       79.47 ms       80.47 ms
day 04, part 2          0.35     2830.12 ms     ±0.74%     2830.12 ms     2845.00 ms
day 05, part 1        321.58        3.11 ms     ±4.21%        3.10 ms        3.42 ms
day 05, part 2        501.76        1.99 ms     ±6.57%        1.97 ms        2.45 ms
day 06, part 1          0.25     4030.05 ms     ±1.01%     4030.05 ms     4058.72 ms
day 06, part 2          0.26     3884.71 ms     ±0.97%     3884.71 ms     3911.36 ms
day 07, part 1        261.52        3.82 ms     ±3.59%        3.79 ms        4.36 ms
day 07, part 2        257.96        3.88 ms    ±11.58%        3.80 ms        4.40 ms
day 08, part 1        556.35        1.80 ms     ±4.11%        1.79 ms        1.93 ms
day 08, part 2        747.55        1.34 ms    ±35.06%        1.29 ms        2.51 ms
day 09, part 1          9.69      103.18 ms     ±3.47%      102.38 ms      124.00 ms
day 09, part 2          9.72      102.91 ms     ±5.29%      101.86 ms      135.82 ms
day 10, part 1         25.20       39.68 ms     ±3.30%       39.63 ms       43.76 ms
day 10, part 2          1.63      612.66 ms     ±7.65%      598.69 ms      688.07 ms
day 11, part 1        735.10        1.36 ms     ±0.59%        1.36 ms        1.39 ms
day 11, part 2         14.87       67.24 ms     ±0.78%       67.00 ms       68.65 ms
day 12, part 1        629.44        1.59 ms     ±6.07%        1.58 ms        1.83 ms
day 12, part 2        412.93        2.42 ms     ±4.61%        2.40 ms        2.63 ms
day 13, part 1          2.61      382.98 ms     ±0.11%      383.11 ms      383.66 ms
day 13, part 2          0.22     4539.85 ms     ±0.83%     4539.85 ms     4566.39 ms
day 14, part 1      11014.61      0.0908 ms   ±237.84%      0.0792 ms       0.140 ms
day 14, part 2         27.00       37.04 ms     ±0.49%       37.01 ms       37.64 ms
day 15, part 1          0.26     3820.75 ms     ±1.46%     3820.75 ms     3860.31 ms
day 15, part 2          0.23     4296.97 ms     ±0.87%     4296.97 ms     4323.25 ms
day 16, part 1        935.63        1.07 ms     ±2.92%        1.06 ms        1.13 ms
day 16, part 2        904.71        1.11 ms     ±7.33%        1.10 ms        1.18 ms
day 17, part 1          1.33      752.84 ms    ±22.34%      750.37 ms     1096.70 ms
day 17, part 2          1.35      738.82 ms    ±18.35%      707.63 ms     1022.19 ms
day 18, part 1          1.26      794.09 ms     ±0.18%      794.26 ms      795.94 ms
day 18, part 2          1.26      794.89 ms     ±0.20%      795.42 ms      796.65 ms
day 19, part 1        205.64        4.86 ms     ±3.90%        4.83 ms        6.27 ms
day 20, part 1          0.36     2778.04 ms     ±0.05%     2778.04 ms     2779.07 ms
day 20, part 2          0.31     3253.41 ms     ±0.20%     3253.41 ms     3258.09 ms
day 21, part 1       5102.04       0.196 ms    ±15.96%       0.187 ms        0.34 ms
day 21, part 2       1574.54        0.64 ms     ±3.84%        0.63 ms        0.72 ms
day 22, part 1          5.39      185.44 ms     ±0.13%      185.40 ms      186.17 ms
day 22, part 2          2.84      352.49 ms     ±0.39%      352.43 ms      356.28 ms
day 23, part 1       1905.97        0.52 ms     ±2.74%        0.52 ms        0.56 ms
day 23, part 2       4523.04        0.22 ms     ±5.43%        0.22 ms        0.25 ms
day 24, part 1          6.24      160.34 ms     ±5.25%      163.51 ms      177.81 ms
day 24, part 2        358.64        2.79 ms     ±8.86%        2.69 ms        3.53 ms
day 25, part 1          8.74      114.43 ms     ±0.09%      114.41 ms      114.64 ms
```
