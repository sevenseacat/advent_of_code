defmodule Y2022.Day18 do
  use Advent.Day, no: 18

  @adjacents [[-1, 0, 0], [1, 0, 0], [0, -1, 0], [0, 1, 0], [0, 0, -1], [0, 0, 1]]

  def part1(input) do
    input
    |> Enum.map(&count_exposed_sides(&1, MapSet.new(input)))
    |> Enum.sum()
  end

  # @doc """
  # iex> Day18.part2("update or delete me")
  # "update or delete me"
  # """
  # def part2(input) do
  #   input
  # end

  defp count_exposed_sides([x, y, z], input) do
    # The number of exposed sides for this cube will be 6 - the number of adjacent cubes
    adjacents =
      Enum.map(@adjacents, fn [a, b, c] -> [x + a, y + b, z + c] end)
      |> Enum.count(fn adjacent -> MapSet.member?(input, adjacent) end)

    6 - adjacents
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn row ->
      Regex.run(~r/^(\d+),(\d+),(\d+)$/, row, capture: :all_but_first)
      |> Enum.map(&String.to_integer/1)
    end)
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  # def part2_verify, do: input() |> parse_input() |> part2()
end
