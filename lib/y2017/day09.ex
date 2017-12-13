defmodule Y2017.Day09 do
  use Advent.Day, no: 09

  @doc """
  iex> Day09.part1("{}")
  1

  iex> Day09.part1("{{{}}}")
  6

  iex> Day09.part1("{{},{}}")
  5

  iex> Day09.part1("{{{},{},{{}}}}")
  16

  iex> Day09.part1("{<a>,<a>,<a>,<a>}")
  1

  iex> Day09.part1("{{<ab>},{<ab>},{<ab>},{<ab>}}")
  9

  iex> Day09.part1("{{<!!>},{<!!>},{<!!>},{<!!>}}")
  9

  iex> Day09.part1("{{<a!>},{<a!>},{<a!>},{<ab>}}")
  3
  """
  def part1(input), do: do_part1(String.codepoints(input), {:group, 0}, 0)

  # Base case
  def do_part1([], {:group, 0}, score), do: score

  # Group terminators
  def do_part1(["{" | rest], {:group, level}, score) do
    do_part1(rest, {:group, level + 1}, score + level + 1)
  end

  def do_part1(["}" | rest], {:group, level}, score) do
    do_part1(rest, {:group, level - 1}, score)
  end

  # Garbage terminators
  def do_part1(["<" | rest], {:group, level}, score) do
    do_part1(rest, {:garbage, level}, score)
  end

  def do_part1([">" | rest], {:garbage, level}, score) do
    do_part1(rest, {:group, level}, score)
  end

  # Everything else
  def do_part1(["!", _ | rest], state, score) do
    do_part1(rest, state, score)
  end

  def do_part1([_ | rest], state, score) do
    do_part1(rest, state, score)
  end

  def part1_verify, do: input() |> part1()
end
