# Advent of Code

[![GitHub Workflow Status](https://img.shields.io/github/workflow/status/sevenseacat/advent_of_code/Elixir%20CI?style=flat-square)](https://github.com/sevenseacat/advent_of_code/actions/workflows/elixir.yml)

My Elixir solutions for [Advent of Code](https://adventofcode.com/) (all years).

<!-- stars start -->
<a href="./lib/y2015/"><img src="https://img.shields.io/badge/2015-%E2%AD%90%EF%B8%8F_50_stars_%E2%AD%90%EF%B8%8F-brightgreen?style=flat-square" alt="50 stars" /></a>
<a href="./lib/y2016/"><img src="https://img.shields.io/badge/2016-%E2%AD%90%EF%B8%8F_50_stars_%E2%AD%90%EF%B8%8F-brightgreen?style=flat-square" alt="50 stars" /></a>
<a href="./lib/y2017/"><img src="https://img.shields.io/badge/2017-%E2%AD%90%EF%B8%8F_50_stars_%E2%AD%90%EF%B8%8F-brightgreen?style=flat-square" alt="50 stars" /></a>
<a href="./lib/y2018/"><img src="https://img.shields.io/badge/2018-%E2%AD%90%EF%B8%8F_50_stars_%E2%AD%90%EF%B8%8F-brightgreen?style=flat-square" alt="50 stars" /></a>
<a href="./lib/y2019/"><img src="https://img.shields.io/badge/2019-35_stars-yellow?style=flat-square" alt="35 stars" /></a>
<a href="./lib/y2020/"><img src="https://img.shields.io/badge/2020-30_stars-yellow?style=flat-square" alt="30 stars" /></a>
<a href="./lib/y2021/"><img src="https://img.shields.io/badge/2021-46_stars-green?style=flat-square" alt="46 stars" /></a>
<a href="./lib/y2022/"><img src="https://img.shields.io/badge/2022-29_stars-yellow?style=flat-square" alt="29 stars" /></a>
<!-- stars end -->

This repository is a work in progress - I haven't yet completed all puzzles, but I'm working on them!

Each yearly event has:

* Daily solutions in `lib/y<year>/day<day>.ex`
* Tests in `tests/y<year>/day<day>_test.exs`
* Benchmarking in `lib/y<year>/README.md`
* Doctests where applicable

Each day's solution follows a general formula:

* A module named after the day, eg. `Y2021.Day19`
* Reading any provided input file with `input/0` (sometimes not used)
* Parsing the input file into a useful structure with `parse_input/1`
* Piping the parsed input into a `part1/1` or `part2/1` function
* Optionally processing the result, eg. if `part1/1` returns a map with extra data but the question only needs a single key value.
* The test module for each day's solution verifies that the code gives the correct answer as input on the site, by calling `part1_verify/0` or `part2_verify/0`.

For the puzzles I completed prior to Advent of Code 2021, I've copied them from their original codebases into this repo commit by commit, modifying them to fit into my new universal structure. I've also kept the original author dates on those commits, some of them date back to 2016!
