defmodule Y2021.Day06 do
  use Advent.Day, no: 6

  @fish_lifespan 6

  @doc """
  iex> Day06.part1([3,4,3,1,2], 1)
  [2,3,2,0,1]

  iex> Day06.part1([3,4,3,1,2], 2)
  [1,2,1,6,0,8]

  iex> Day06.part1([3,4,3,1,2], 3)
  [0,1,0,5,6,7,8]

  iex> Day06.part1([3,4,3,1,2], 10)
  [0,1,0,5,6,0,1,2,2,3,7,8]

  iex> Day06.part1([3,4,3,1,2], 80) |> length
  5934
  """
  def part1(input, max_days) do
    do_part1(input, 0, max_days)
  end

  defp do_part1(fish, max, max), do: fish

  defp do_part1(fish, current, max) do
    fish
    |> next_day()
    |> do_part1(current + 1, max)
  end

  defp next_day(fish) do
    new_fish_count = Enum.count(fish, &(&1 == 0))
    age_fish(fish) ++ new_fish(new_fish_count)
  end

  defp age_fish([]), do: []
  defp age_fish([fish | fishes]), do: [age_fish(fish) | age_fish(fishes)]

  defp age_fish(0), do: @fish_lifespan
  defp age_fish(num), do: num - 1

  defp new_fish(count), do: List.duplicate(@fish_lifespan + 2, count)

  def parse_input(input) do
    input
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  def part1_verify, do: input() |> parse_input() |> part1(80) |> length
end
