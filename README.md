# Advent of Code

[![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/sevenseacat/advent_of_code/elixir.yml?branch=main&style=flat-square)](https://github.com/sevenseacat/advent_of_code/actions/workflows/elixir.yml)

My Elixir solutions for [Advent of Code](https://adventofcode.com/) (all years).

<!-- stars start -->
<p><img src="https://img.shields.io/static/v1?label=Total&message=432%20stars&style=for-the-badge&color=green" alt="432 stars" /></p>
<p><a href="./lib/y2024/"><img src="https://img.shields.io/static/v1?label=2024&message=14%20stars&style=for-the-badge&color=orange" alt="14 stars" /></a><br />
<a href="./lib/y2023/"><img src="https://img.shields.io/static/v1?label=2023&message=44%20stars&style=for-the-badge&color=green" alt="44 stars" /></a><br />
<a href="./lib/y2022/"><img src="https://img.shields.io/static/v1?label=2022&message=%E2%AD%90%EF%B8%8F%2050%20stars%20%E2%AD%90%EF%B8%8F&style=for-the-badge&color=brightgreen" alt="50 stars" /></a><br />
<a href="./lib/y2021/"><img src="https://img.shields.io/static/v1?label=2021&message=46%20stars&style=for-the-badge&color=green" alt="46 stars" /></a><br />
<a href="./lib/y2020/"><img src="https://img.shields.io/static/v1?label=2020&message=39%20stars&style=for-the-badge&color=yellow" alt="39 stars" /></a><br />
<a href="./lib/y2019/"><img src="https://img.shields.io/static/v1?label=2019&message=39%20stars&style=for-the-badge&color=yellow" alt="39 stars" /></a><br />
<a href="./lib/y2018/"><img src="https://img.shields.io/static/v1?label=2018&message=%E2%AD%90%EF%B8%8F%2050%20stars%20%E2%AD%90%EF%B8%8F&style=for-the-badge&color=brightgreen" alt="50 stars" /></a><br />
<a href="./lib/y2017/"><img src="https://img.shields.io/static/v1?label=2017&message=%E2%AD%90%EF%B8%8F%2050%20stars%20%E2%AD%90%EF%B8%8F&style=for-the-badge&color=brightgreen" alt="50 stars" /></a><br />
<a href="./lib/y2016/"><img src="https://img.shields.io/static/v1?label=2016&message=%E2%AD%90%EF%B8%8F%2050%20stars%20%E2%AD%90%EF%B8%8F&style=for-the-badge&color=brightgreen" alt="50 stars" /></a><br />
<a href="./lib/y2015/"><img src="https://img.shields.io/static/v1?label=2015&message=%E2%AD%90%EF%B8%8F%2050%20stars%20%E2%AD%90%EF%B8%8F&style=for-the-badge&color=brightgreen" alt="50 stars" /></a></p><!-- stars end -->

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
