defmodule Y2021.Day06 do
  use Advent.Day, no: 6

  @fish_lifespan 6

  @doc """
  iex> Day06.parts([3,4,3,1,2], 1)
  [2,3,2,0,1] |> length

  iex> Day06.parts([3,4,3,1,2], 2)
  [1,2,1,6,0,8] |> length

  iex> Day06.parts([3,4,3,1,2], 3)
  [0,1,0,5,6,7,8] |> length

  iex> Day06.parts([3,4,3,1,2], 10)
  [0,1,0,5,6,0,1,2,2,3,7,8] |> length

  iex> Day06.parts([3,4,3,1,2], 80)
  5934

  iex> Day06.parts([3,4,3,1,2], 256)
  26_984_457_539
  """
  def parts(input, max_days) do
    input
    |> Enum.frequencies()
    |> do_parts(0, max_days)
    |> Map.values()
    |> Enum.sum()
  end

  defp do_parts(fish, max, max), do: fish

  defp do_parts(fish, current, max) do
    fish
    |> next_day()
    |> do_parts(current + 1, max)
  end

  defp next_day(fish) do
    Enum.reduce(fish, %{}, fn
      {0, count}, acc -> acc |> add_fish(@fish_lifespan, count) |> add_fish(8, count)
      {num, count}, acc -> acc |> add_fish(num - 1, count)
    end)
  end

  defp add_fish(map, num, val), do: Map.update(map, num, val, &(&1 + val))

  def parse_input(input) do
    input
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  def part1_verify, do: input() |> parse_input() |> parts(80)
  def part2_verify, do: input() |> parse_input() |> parts(256)
end
