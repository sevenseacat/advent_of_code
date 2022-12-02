# Advent of Code

[![Elixir CI](https://github.com/sevenseacat/advent_of_code/actions/workflows/elixir.yml/badge.svg)](https://github.com/sevenseacat/advent_of_code/actions/workflows/elixir.yml)

My Elixir solutions for [Advent of Code](https://adventofcode.com/) (all years).

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

## My current stats

* [2015 - 48/50 :star:](/lib/y2015/) 
* [2016 - 43/50 :star:](/lib/y2016/)
* [2017 - 50/50 :star:](/lib/y2017/)
* [2018 - 50/50 :star:](/lib/y2018/)
* [2019 - 31/50 :star:](/lib/y2019/)
* [2020 - 29/50 :star:](/lib/y2020/)
* [2021 - 46/50 :star:](/lib/y2021/)
* [2022 - 4/4 :star:](/lib/y2022/)
