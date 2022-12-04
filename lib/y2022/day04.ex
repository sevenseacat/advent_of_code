defmodule Y2022.Day04 do
  use Advent.Day, no: 04

  def part1(input) do
    input
    |> Enum.filter(&overlapping?/1)
    |> length
  end

  defp overlapping?({one, two}) do
    overlapping?(one, two) || overlapping?(two, one)
  end

  defp overlapping?({a, b}, {c, d}) do
    a <= c && b >= d
  end

  @doc """
  iex> Day04.parse_input("2-4,6-8\\n2-3,4-5")
  [{{2,4},{6,8}}, {{2,3}, {4,5}}]
  """
  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn row ->
      [one, two, three, four] =
        Regex.run(~r/(\d+)-(\d+),(\d+)-(\d+)/, row, capture: :all_but_first)
        |> Enum.map(&String.to_integer/1)

      {{one, two}, {three, four}}
    end)
  end

  def part1_verify, do: input() |> parse_input() |> part1()
end
