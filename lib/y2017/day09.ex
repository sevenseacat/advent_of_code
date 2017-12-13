defmodule Y2017.Day09 do
  use Advent.Day, no: 09

  @doc """
  iex> Day09.parts("{}")
  {1, 0}

  iex> Day09.parts("{{{}}}")
  {6, 0}

  iex> Day09.parts("{{},{}}")
  {5, 0}

  iex> Day09.parts("{{{},{},{{}}}}")
  {16, 0}

  iex> Day09.parts("{<a>,<a>,<a>,<a>}")
  {1, 4}

  iex> Day09.parts("{{<ab>},{<ab>},{<ab>},{<ab>}}")
  {9, 8}

  iex> Day09.parts("{{<!!>},{<!!>},{<!!>},{<!!>}}")
  {9, 0}

  iex> Day09.parts("{{<a!>},{<a!>},{<a!>},{<ab>}}")
  {3, 17}
  """
  def parts(input), do: do_parts(String.codepoints(input), {:group, 0}, {0, 0})

  # Base case
  def do_parts([], {:group, 0}, results), do: results

  # Group terminators
  def do_parts(["{" | rest], {:group, level}, {score, cancelled}) do
    do_parts(rest, {:group, level + 1}, {score + level + 1, cancelled})
  end

  def do_parts(["}" | rest], {:group, level}, results) do
    do_parts(rest, {:group, level - 1}, results)
  end

  # Garbage terminators
  def do_parts(["<" | rest], {:group, level}, results) do
    do_parts(rest, {:garbage, level}, results)
  end

  def do_parts([">" | rest], {:garbage, level}, results) do
    do_parts(rest, {:group, level}, results)
  end

  # Everything else
  def do_parts(["!", _ | rest], state, results) do
    do_parts(rest, state, results)
  end

  def do_parts([_ | rest], {:group, _} = state, results) do
    do_parts(rest, state, results)
  end

  def do_parts([_ | rest], {:garbage, _} = state, {score, cancelled}) do
    do_parts(rest, state, {score, cancelled + 1})
  end

  def part1_verify, do: input() |> parts() |> elem(0)
  def part2_verify, do: input() |> parts() |> elem(1)
end
