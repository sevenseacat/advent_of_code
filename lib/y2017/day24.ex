defmodule Y2017.Day24 do
  use Advent.Day, no: 24

  @doc """
  iex> Day24.part1([{0,2}, {2,2}, {0,1}, {10,1}, {2,3}, {3,4}, {3,5}, {9,10}])
  {[{0,1}, {10,1}, {9,10}], 31}
  """
  def part1(pipes) do
    pipes
    |> find_next_nodes(0)
    |> generate_bridges(pipes)
    |> find_strongest
  end

  defp find_next_nodes(pipes, val) do
    Enum.filter(pipes, fn {a, b} -> a == val or b == val end)
  end

  defp generate_bridges(starting, pipes) do
    Enum.flat_map(starting, &build_bridges([&1], open_end([&1], 0), pipes -- [&1]))
  end

  @doc """
  Build all possible bridges from a set of pipes stored in `rest`.
  """
  def build_bridges(bridge, open_end, rest) do
    next_nodes = find_next_nodes(rest, open_end)

    Enum.reduce(next_nodes, [bridge], fn next, acc ->
      acc ++ build_bridges(bridge ++ [next], open_end([next], open_end), rest -- [next])
    end)
  end

  @doc """
  iex> Day24.open_end([{0,1}], 0)
  1

  iex> Day24.open_end([{0,2}, {2,3}], 0)
  3

  iex> Day24.open_end([{0,1}, {10,1}, {9,10}], 0)
  9
  """
  def open_end([], open), do: open
  def open_end([{open, other} | t], open), do: open_end(t, other)
  def open_end([{other, open} | t], open), do: open_end(t, other)

  def find_strongest(bridges) do
    bridges
    |> Enum.map(&strength/1)
    |> Enum.max_by(fn {_, b} -> b end)
  end

  @doc """
  iex> Day24.strength([{0, 1}])
  {[{0,1}], 1}

  iex> Day24.strength([{0,1}, {10,1}])
  {[{0,1}, {10,1}], 12}

  iex> Day24.strength([{0,1}, {10,1}, {9,10}])
  {[{0,1}, {10,1}, {9,10}], 31}

  iex> Day24.strength([{0,2}, {2,2}, {2,3}])
  {[{0,2}, {2,2}, {2,3}], 11}

  iex> Day24.strength([{0,2}, {2,2}, {2,3}, {3,4}])
  {[{0,2}, {2,2}, {2,3}, {3,4}], 18}
  """
  def strength(bridge) do
    {bridge, Enum.reduce(bridge, 0, fn {a, b}, acc -> acc + a + b end)}
  end

  @doc """
  iex> Day24.parse_input("25/13
  ...>4/43
  ...>42/42")
  [{25, 13}, {4, 43}, {42, 42}]
  """
  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&to_pipe/1)
  end

  defp to_pipe(string) do
    string
    |> String.split("/")
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

  def part1_verify, do: input() |> parse_input() |> part1() |> elem(1)
end
