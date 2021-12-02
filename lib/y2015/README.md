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
day 01, part 1       6513.12       0.154 ms    ±18.72%       0.153 ms       0.184 ms
day 01, part 2      11560.84      0.0865 ms    ±29.24%      0.0830 ms       0.147 ms
day 02, part 1       1108.98        0.90 ms     ±6.31%        0.89 ms        1.08 ms
day 02, part 2        744.81        1.34 ms     ±6.03%        1.32 ms        1.57 ms
day 03, part 1        238.44        4.19 ms    ±10.73%        4.05 ms        6.64 ms
day 03, part 2        232.50        4.30 ms     ±7.70%        4.26 ms        5.20 ms
day 04, part 1          8.00      124.94 ms     ±0.99%      124.64 ms      127.51 ms
day 04, part 2          0.22     4651.09 ms     ±0.04%     4651.09 ms     4652.55 ms
day 05, part 1        151.23        6.61 ms     ±2.75%        6.59 ms        7.39 ms
day 05, part 2        159.04        6.29 ms    ±41.28%        5.26 ms       13.96 ms
day 06, part 1         0.125     7979.11 ms     ±0.00%     7979.11 ms     7979.11 ms
day 06, part 2         0.130     7692.00 ms     ±0.00%     7692.00 ms     7692.00 ms
day 07, part 1        137.85        7.25 ms    ±22.25%        6.76 ms       14.25 ms
day 07, part 2        110.80        9.03 ms    ±31.38%        6.82 ms       14.67 ms
day 08, part 1        212.52        4.71 ms    ±13.50%        4.47 ms        7.54 ms
day 08, part 2        396.16        2.52 ms     ±6.87%        2.48 ms        3.12 ms
day 09, part 1          5.89      169.84 ms     ±1.04%      169.07 ms      174.90 ms
day 09, part 2          5.89      169.80 ms     ±0.95%      169.48 ms      173.99 ms
day 10, part 1         12.45       80.30 ms     ±5.38%       80.79 ms       90.05 ms
day 10, part 2          0.77     1292.14 ms     ±9.01%     1280.93 ms     1441.25 ms
day 11, part 1        380.65        2.63 ms     ±2.31%        2.61 ms        2.87 ms
day 11, part 2          7.83      127.73 ms     ±1.01%      128.05 ms      129.96 ms
day 12, part 1        211.55        4.73 ms     ±3.35%        4.70 ms        5.27 ms
day 12, part 2        179.39        5.57 ms     ±4.59%        5.51 ms        6.35 ms
day 13, part 1          1.45      689.23 ms     ±0.36%      688.90 ms      694.44 ms
day 13, part 2         0.115     8664.59 ms     ±0.00%     8664.59 ms     8664.59 ms
day 14, part 1       8964.39       0.112 ms    ±26.45%       0.103 ms        0.23 ms
day 14, part 2          9.57      104.48 ms     ±0.92%      104.28 ms      108.65 ms
day 15, part 1         0.114     8790.70 ms     ±0.00%     8790.70 ms     8790.70 ms
day 15, part 2         0.110     9060.64 ms     ±0.00%     9060.64 ms     9060.64 ms
day 16, part 1        476.13        2.10 ms     ±5.43%        2.06 ms        2.47 ms
day 16, part 2        459.07        2.18 ms     ±6.13%        2.15 ms        2.68 ms
day 17, part 1          0.54     1865.09 ms    ±23.21%     1730.75 ms     2349.29 ms
day 17, part 2          0.47     2128.34 ms    ±17.53%     2137.93 ms     2496.58 ms
day 18, part 1          0.66     1518.11 ms     ±0.79%     1514.79 ms     1535.25 ms
day 18, part 2          0.66     1519.99 ms     ±0.47%     1520.54 ms     1526.87 ms
day 19, part 1         94.62       10.57 ms     ±2.61%       10.55 ms       11.81 ms
day 20, part 1         0.103     9729.01 ms     ±0.00%     9729.01 ms     9729.01 ms
day 20, part 2        0.0899    11129.44 ms     ±0.00%    11129.44 ms    11129.44 ms
day 21, part 1       1729.24        0.58 ms    ±10.75%        0.56 ms        0.80 ms
day 21, part 2        854.18        1.17 ms     ±6.53%        1.14 ms        1.38 ms
day 22, part 1          2.24      445.91 ms     ±0.87%      445.88 ms      452.68 ms
day 22, part 2          1.41      708.52 ms     ±0.70%      706.74 ms      718.18 ms
day 23, part 1       2395.00        0.42 ms     ±6.75%        0.42 ms        0.50 ms
day 23, part 2       2092.71        0.48 ms     ±5.76%        0.48 ms        0.57 ms
day 24, part 1          2.77      361.31 ms    ±10.67%      344.79 ms      442.51 ms
day 24, part 2        139.51        7.17 ms    ±10.61%        7.35 ms        9.32 ms
day 25, part 1          2.97      336.95 ms     ±0.09%      336.88 ms      337.60 ms
```
