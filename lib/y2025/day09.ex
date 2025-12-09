defmodule Y2025.Day09 do
  use Advent.Day, no: 09

  def part1(input) do
    input
    |> Advent.permutations(2)
    |> Enum.map(fn [a, b] -> {a, b, rectangle_size({a, b})} end)
    |> Enum.max_by(fn {_a, _b, size} -> size end)
    |> elem(2)
  end

  # @doc """
  # iex> Day09.part2("update or delete me")
  # "update or delete me"
  # """
  # def part2(input) do
  #   input
  # end

  @doc """
  iex> Day09.rectangle_size({{2,5}, {11,1}})
  50

  iex> Day09.rectangle_size({{7,3}, {2,3}})
  6
  """
  def rectangle_size({{row1, col1}, {row2, col2}}) do
    (abs(row2 - row1) + 1) * (abs(col2 - col1) + 1)
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn row ->
      row
      |> String.split(",", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  # def part2_verify, do: input() |> parse_input() |> part2()
end
