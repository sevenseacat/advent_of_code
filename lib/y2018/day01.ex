defmodule Y2018.Day01 do
  use Advent.Day, no: 1

  @doc """
  iex> Day01.part1("+1\\n+1\\n+1")
  3

  iex> Day01.part1("+1\\n+1\\n-2")
  0

  iex> Day01.part1("-1\\n-2\\n-3")
  -6
  """
  def part1(data) do
    data
    |> String.split()
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
  end

  def part1_verify, do: input() |> part1()
end
