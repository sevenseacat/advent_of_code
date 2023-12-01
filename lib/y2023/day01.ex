defmodule Y2023.Day01 do
  use Advent.Day, no: 01

  @doc """
  iex> Day01.part1(["1abc2", "pqr3stu8vwx", "a1b2c3d4e5f", "treb7uchet"])
  142
  """
  def part1(input) do
    input
    |> Enum.map(&to_integer/1)
    |> Enum.sum()
  end

  # @doc """
  # iex> Day01.part2("update or delete me")
  # "update or delete me"
  # """
  # def part2(input) do
  #   input
  # end

  defp to_integer(string) do
    numbers = Regex.replace(~r/[a-z]/, string, "")
    String.to_integer("#{String.first(numbers)}#{String.last(numbers)}")
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  # def part2_verify, do: input() |> parse_input() |> part2()
end
