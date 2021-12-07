defmodule Y2021.Day07 do
  use Advent.Day, no: 7

  @doc """
  iex> Day07.part1([16,1,2,0,4,2,7,1,2,14])
  {2, 37}
  """
  def part1(crabs) do
    do_parts(crabs, &flat_fuel/2)
  end

  @doc """
  iex> Day07.part2([16,1,2,0,4,2,7,1,2,14])
  {5, 168}
  """
  def part2(crabs) do
    do_parts(crabs, &varying_fuel/2)
  end

  defp do_parts(crabs, func) do
    {min, max} = Enum.min_max(crabs)

    for position <- min..max do
      calculate_fuel(crabs, position, func)
    end
    |> Enum.min_by(fn {_pos, fuel} -> fuel end)
  end

  defp calculate_fuel(crabs, position, func) do
    crabs
    |> Enum.map(fn crab -> func.(crab, position) end)
    |> Enum.sum()
    |> then(fn fuel -> {position, fuel} end)
  end

  defp flat_fuel(crab, position), do: abs(crab - position)

  defp varying_fuel(crab, position) do
    flat_fuel = flat_fuel(crab, position)
    div(flat_fuel * (flat_fuel + 1), 2)
  end

  def parse_input(input) do
    input
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def part1_verify, do: input() |> parse_input |> part1() |> elem(1)
  def part2_verify, do: input() |> parse_input |> part2() |> elem(1)
end
