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
day 01, part 1       5888.79       0.170 ms    ±21.17%       0.171 ms        0.24 ms
day 01, part 2       9987.53       0.100 ms    ±25.90%      0.0900 ms       0.187 ms
day 02, part 1       1001.18        1.00 ms    ±14.17%        0.97 ms        1.62 ms
day 02, part 2        714.21        1.40 ms     ±7.60%        1.39 ms        1.77 ms
day 03, part 1        253.23        3.95 ms    ±12.30%        3.78 ms        5.73 ms
day 03, part 2        227.79        4.39 ms     ±8.83%        4.34 ms        5.52 ms
day 04, part 1          6.85      146.01 ms     ±0.90%      145.79 ms      151.27 ms
day 04, part 2         0.187     5361.67 ms     ±0.00%     5361.67 ms     5361.67 ms
day 05, part 1        152.65        6.55 ms     ±2.47%        6.54 ms        7.14 ms
day 05, part 2        186.29        5.37 ms     ±2.85%        5.34 ms        5.98 ms
day 06, part 1         0.127     7892.56 ms     ±0.00%     7892.56 ms     7892.56 ms
day 06, part 2         0.129     7731.74 ms     ±0.00%     7731.74 ms     7731.74 ms
day 07, part 1        149.17        6.70 ms     ±1.91%        6.67 ms        7.41 ms
day 07, part 2        149.37        6.69 ms     ±2.24%        6.66 ms        7.49 ms
day 08, part 1        227.63        4.39 ms     ±3.27%        4.37 ms        4.93 ms
day 08, part 2        424.95        2.35 ms     ±4.62%        2.34 ms        2.77 ms
day 09, part 1          5.86      170.55 ms     ±1.71%      169.99 ms      177.45 ms
day 09, part 2          5.86      170.61 ms     ±1.23%      169.98 ms      175.29 ms
day 10, part 1         11.86       84.34 ms     ±5.71%       84.16 ms       93.64 ms
day 10, part 2          0.73     1376.45 ms     ±9.38%     1365.05 ms     1543.59 ms
day 11, part 1        373.11        2.68 ms     ±2.30%        2.66 ms        2.93 ms
day 11, part 2          7.68      130.28 ms     ±0.87%      130.34 ms      134.88 ms
day 12, part 1        198.09        5.05 ms     ±5.10%        5.02 ms        5.84 ms
day 12, part 2        170.08        5.88 ms     ±5.59%        5.85 ms        6.87 ms
day 13, part 1          1.44      694.50 ms     ±0.69%      694.11 ms      702.92 ms
day 13, part 2         0.117     8540.05 ms     ±0.00%     8540.05 ms     8540.05 ms
day 14, part 1       8977.44       0.111 ms    ±22.45%       0.104 ms        0.21 ms
day 14, part 2          9.32      107.26 ms     ±1.28%      106.98 ms      114.45 ms
day 15, part 1         0.110     9090.48 ms     ±0.00%     9090.48 ms     9090.48 ms
day 15, part 2         0.109     9210.43 ms     ±0.00%     9210.43 ms     9210.43 ms
day 16, part 1        443.46        2.25 ms    ±11.24%        2.19 ms        2.89 ms
day 16, part 2        437.48        2.29 ms    ±11.34%        2.19 ms        2.93 ms
day 17, part 1          0.52     1924.03 ms    ±23.24%     1805.21 ms     2418.62 ms
day 17, part 2          0.46     2193.12 ms    ±17.87%     2202.86 ms     2580.00 ms
day 18, part 1          0.63     1578.34 ms     ±5.35%     1549.54 ms     1700.69 ms
day 18, part 2          0.66     1521.84 ms     ±2.27%     1510.26 ms     1572.20 ms
day 19, part 1         94.88       10.54 ms     ±2.04%       10.47 ms       11.45 ms
day 20, part 1         0.101     9938.68 ms     ±0.00%     9938.68 ms     9938.68 ms
day 20, part 2        0.0873    11448.58 ms     ±0.00%    11448.58 ms    11448.58 ms
day 21, part 1       1688.45        0.59 ms    ±14.92%        0.57 ms        0.88 ms
day 21, part 2        838.91        1.19 ms     ±7.33%        1.16 ms        1.46 ms
day 22, part 1          0.50     2006.75 ms     ±0.69%     2011.94 ms     2017.21 ms
day 22, part 2          0.26     3870.08 ms     ±0.72%     3870.08 ms     3889.80 ms
day 23, part 1       2389.05        0.42 ms     ±6.64%        0.42 ms        0.51 ms
day 23, part 2       2078.35        0.48 ms     ±6.14%        0.48 ms        0.58 ms
day 24, part 1          2.75      363.95 ms    ±10.12%      347.22 ms      456.91 ms
day 24, part 2        137.09        7.29 ms    ±11.78%        7.51 ms        9.51 ms
day 25, part 1          2.96      337.65 ms     ±0.30%      337.24 ms      339.70 ms
```
