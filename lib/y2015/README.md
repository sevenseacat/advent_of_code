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
day 01, part 1       6193.93       0.161 ms    ±15.07%       0.158 ms        0.21 ms
day 01, part 2      10676.22      0.0937 ms    ±45.53%      0.0870 ms       0.164 ms
day 02, part 1       1088.09        0.92 ms     ±6.81%        0.91 ms        1.11 ms
day 02, part 2        739.23        1.35 ms     ±6.05%        1.33 ms        1.59 ms
day 03, part 1        259.17        3.86 ms    ±22.74%        3.68 ms        5.18 ms
day 03, part 2        228.74        4.37 ms     ±7.44%        4.38 ms        5.26 ms
day 04, part 1          6.82      146.68 ms     ±1.39%      146.48 ms      152.51 ms
day 04, part 2         0.186     5366.39 ms     ±0.00%     5366.39 ms     5366.39 ms
day 05, part 1        143.34        6.98 ms     ±4.49%        6.94 ms        7.80 ms
day 05, part 2        175.35        5.70 ms    ±18.81%        5.37 ms       10.94 ms
day 06, part 1         0.126     7937.84 ms     ±0.00%     7937.84 ms     7937.84 ms
day 06, part 2         0.130     7720.14 ms     ±0.00%     7720.14 ms     7720.14 ms
day 07, part 1        122.33        8.17 ms    ±30.11%        6.73 ms       14.42 ms
day 07, part 2        139.58        7.16 ms    ±21.43%        6.68 ms       12.92 ms
day 08, part 1        223.22        4.48 ms     ±4.98%        4.43 ms        5.42 ms
day 08, part 2        408.40        2.45 ms     ±5.80%        2.42 ms        3.00 ms
day 09, part 1          5.82      171.68 ms     ±3.08%      170.53 ms      194.82 ms
day 09, part 2          5.84      171.33 ms     ±1.33%      171.29 ms      175.75 ms
day 10, part 1         11.68       85.63 ms     ±6.73%       84.93 ms      105.75 ms
day 10, part 2          0.73     1376.04 ms    ±11.07%     1341.58 ms     1589.78 ms
day 11, part 1        371.66        2.69 ms     ±2.64%        2.67 ms        2.94 ms
day 11, part 2          7.69      130.04 ms     ±0.89%      130.10 ms      134.06 ms
day 12, part 1        199.27        5.02 ms     ±5.79%        5.00 ms        5.77 ms
day 12, part 2        175.29        5.70 ms     ±7.66%        5.63 ms        7.57 ms
day 13, part 1          1.44      692.62 ms     ±1.33%      693.18 ms      706.75 ms
day 13, part 2         0.116     8614.11 ms     ±0.00%     8614.11 ms     8614.11 ms
day 14, part 1       8850.06       0.113 ms    ±29.82%       0.104 ms        0.23 ms
day 14, part 2          9.34      107.09 ms     ±0.80%      106.96 ms      109.61 ms
day 15, part 1         0.110     9064.44 ms     ±0.00%     9064.44 ms     9064.44 ms
day 15, part 2         0.108     9282.53 ms     ±0.00%     9282.53 ms     9282.53 ms
day 16, part 1        441.37        2.27 ms    ±14.43%        2.21 ms        3.66 ms
day 16, part 2        451.66        2.21 ms     ±9.49%        2.15 ms        2.79 ms
day 17, part 1          0.45     2213.83 ms    ±17.51%     2219.48 ms     2598.67 ms
day 17, part 2          0.45     2220.42 ms    ±17.36%     2227.97 ms     2602.11 ms
day 18, part 1          0.66     1503.95 ms     ±0.71%     1499.20 ms     1519.87 ms
day 18, part 2          0.67     1498.81 ms     ±0.65%     1495.65 ms     1513.01 ms
day 19, part 1         96.18       10.40 ms     ±2.65%       10.31 ms       11.49 ms
day 20, part 1        0.0699    14301.96 ms     ±0.00%    14301.96 ms    14301.96 ms
day 20, part 2        0.0619    16159.27 ms     ±0.00%    16159.27 ms    16159.27 ms
day 21, part 1       1747.41        0.57 ms    ±11.24%        0.55 ms        0.79 ms
day 21, part 2        856.78        1.17 ms     ±5.35%        1.14 ms        1.36 ms
day 22, part 1          0.50     2014.79 ms     ±2.08%     1994.90 ms     2063.04 ms
day 22, part 2          0.26     3835.40 ms     ±0.52%     3835.40 ms     3849.49 ms
day 23, part 1       2379.45        0.42 ms    ±10.02%        0.42 ms        0.52 ms
day 23, part 2       2076.84        0.48 ms     ±5.70%        0.48 ms        0.58 ms
day 24, part 1          3.12      320.89 ms    ±15.19%      320.58 ms      479.01 ms
day 24, part 2        139.40        7.17 ms    ±11.06%        7.36 ms        9.34 ms
day 25, part 1          2.96      337.46 ms     ±0.37%      337.04 ms      341.67 ms
```

(I rushed a lot towards the end of these solutions, and didn't spend any time optimizing them - hence they're comparitively pretty slow. But good enough!)
