defmodule Y2015.Day12 do
  use Advent.Day, no: 12

  @doc """
  iex> Day12.part1("{\\"a\\":2,\\"b\\":4}")
  6

  iex> Day12.part1("{\\"a\\":[-1,1]}")
  0

  iex> Day12.part1("{}")
  0

  iex> Day12.part1("[[[3]]]")
  3
  """
  def part1(input) do
    Regex.scan(~r/-?\d+/, input)
    |> List.flatten()
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
  end

  def part1_verify, do: input() |> part1()
end
