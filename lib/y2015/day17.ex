defmodule Y2015.Day17 do
  use Advent.Day, no: 17

  @input [50, 44, 11, 49, 42, 46, 18, 32, 26, 40, 21, 7, 18, 43, 10, 47, 36, 24, 22, 40]
  @litres 150

  @doc """
  iex> Day17.part1([20, 15, 10, 5, 5], 25)
  4
  """
  def part1(input \\ @input, litres \\ @litres) do
    1..length(input)
    |> Enum.reduce([], fn length, acc -> acc ++ Advent.combinations(input, length) end)
    |> Enum.filter(fn list -> Enum.sum(list) == litres end)
    |> Enum.count()
  end

  def part1_verify, do: part1()
end
