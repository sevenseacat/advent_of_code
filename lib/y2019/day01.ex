defmodule Y2019.Day01 do
  use Advent.Day, no: 1

  def part1(input) do
    input
    |> Enum.map(&fuel_mass/1)
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> Enum.map(&fuel_mass_with_extra/1)
    |> Enum.sum()
  end

  def parse_input(data) do
    data
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
  end

  @doc """
  iex> Day01.fuel_mass(12)
  2

  iex> Day01.fuel_mass(14)
  2

  iex> Day01.fuel_mass(1969)
  654

  iex> Day01.fuel_mass(100756)
  33583
  """
  def fuel_mass(num), do: div(num, 3) - 2

  @doc """
  iex> Day01.fuel_mass_with_extra(100756)
  50346
  """
  def fuel_mass_with_extra(num, sum \\ 0) do
    needed = fuel_mass(num)

    if needed >= 0, do: fuel_mass_with_extra(needed, sum + needed), else: sum
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  def part2_verify, do: input() |> parse_input() |> part2()
end
