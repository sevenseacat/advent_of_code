defmodule Y2021.Day07 do
  use Advent.Day, no: 7

  @doc """
  iex> Day07.part1([16,1,2,0,4,2,7,1,2,14])
  {2, 37}
  """
  def part1(crabs) do
    for position <- 0..Enum.max(crabs) do
      calculate_fuel(crabs, position)
    end
    |> Enum.min_by(fn {_pos, fuel} -> fuel end)
  end

  defp calculate_fuel(crabs, position) do
    crabs
    |> Enum.map(fn crab -> abs(crab - position) end)
    |> Enum.sum()
    |> then(fn fuel -> {position, fuel} end)
  end

  def parse_input(input) do
    input
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def part1_verify, do: input() |> parse_input |> part1() |> elem(1)
end
