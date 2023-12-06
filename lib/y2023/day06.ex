defmodule Y2023.Day06 do
  use Advent.Day, no: 06

  @mapping [
    %{time: 40, distance: 215},
    %{time: 70, distance: 1051},
    %{time: 98, distance: 2147},
    %{time: 79, distance: 1005}
  ]

  def part1(input) do
    input
    |> dbg
    |> Enum.map(&winnings_per_race/1)
    |> Enum.product()
  end

  # @doc """
  # iex> Day06.part2("update or delete me")
  # "update or delete me"
  # """
  # def part2(input) do
  #   input
  # end

  @doc """
  iex> Day06.winnings_per_race(%{time: 7, distance: 9})
  4

  iex> Day06.winnings_per_race(%{time: 15, distance: 40})
  8

  iex> Day06.winnings_per_race(%{time: 30, distance: 200})
  9
  """
  def winnings_per_race(%{time: time, distance: distance}) do
    Enum.count(1..time, fn t -> (time - t) * t > distance end)
  end

  def part1_verify, do: part1(@mapping)
  # def part2_verify, do: input() |> parse_input() |> part2()
end
