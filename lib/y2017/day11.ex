defmodule Y2017.Day11 do
  use Advent.Day, no: 11

  @doc """
  iex> Day11.part1("ne,ne,ne")
  3

  iex> Day11.part1("ne,ne,sw,sw")
  0

  iex> Day11.part1("ne,ne,s,s")
  2

  iex> Day11.part1("se,sw,se,sw,sw")
  3
  """
  def part1(input) do
    input
    |> String.trim()
    |> String.split(",")
    |> reduce_by_hex({0, 0}, 0)
    |> elem(0)
    |> calculate_distance
  end

  def part2(input) do
    input
    |> String.trim()
    |> String.split(",")
    |> reduce_by_hex({0, 0}, 0)
    |> elem(1)
  end

  # To reduce 3 dimensions to 2 dimensions, a N move can be represented as a combined NE+NW move.
  defp reduce_by_hex([], position, max), do: {position, max}

  defp reduce_by_hex([move | moves], {nw, ne}, max) do
    new_position =
      case move do
        "nw" -> {nw + 1, ne}
        "n" -> {nw + 1, ne + 1}
        "ne" -> {nw, ne + 1}
        "se" -> {nw - 1, ne}
        "s" -> {nw - 1, ne - 1}
        "sw" -> {nw, ne - 1}
      end

    new_max = Enum.max([abs(nw), abs(ne), max])
    reduce_by_hex(moves, new_position, new_max)
  end

  def calculate_distance({nw, ne}), do: Enum.max([abs(nw), abs(ne)])

  def part1_verify, do: input() |> part1()
  def part2_verify, do: input() |> part2()
end
