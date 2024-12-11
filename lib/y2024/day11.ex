defmodule Y2024.Day11 do
  use Advent.Day, no: 11

  @doc """
  iex> Day11.part1([0, 1, 10, 99, 999], 1)
  [1, 2024, 1, 0, 9, 9, 2021976]

  iex> Day11.part1([125, 17], 1)
  [253000, 1, 7]

  iex> Day11.part1([125, 17], 2)
  [253, 0, 2024, 14168]

  iex> Day11.part1([125, 17], 3)
  [512072, 1, 20, 24, 28676032]

  iex> Day11.part1([125, 17], 4)
  [512, 72, 2024, 2, 0, 2, 4, 2867, 6032]

  iex> Day11.part1([125, 17], 5)
  [1036288, 7, 2, 20, 24, 4048, 1, 4048, 8096, 28, 67, 60, 32]

  iex> Day11.part1([125, 17], 6)
  [2097446912, 14168, 4048, 2, 0, 2, 4, 40, 48, 2024, 40, 48, 80, 96, 2, 8, 6, 7, 6, 0, 3, 2]
  """
  def part1(input, times \\ 1) do
    input
    |> Enum.map(fn num -> %{number: num, digits: digits(num)} end)
    |> blink(times)
    |> Enum.map(& &1.number)
  end

  defp blink(input, 0), do: input

  defp blink(input, times) do
    input
    |> Enum.reduce([], fn item, acc ->
      {_, replace} = Enum.find(rules(), fn {match?, _} -> match?.(item) end)
      [replace.(item) | acc]
    end)
    |> Enum.reverse()
    |> List.flatten()
    |> blink(times - 1)
  end

  defp rules do
    [
      {fn stone -> stone.number == 0 end, fn stone -> Map.put(stone, :number, 1) end},
      {fn stone -> rem(stone.digits, 2) == 0 end,
       fn stone ->
         left = div(stone.number, Integer.pow(10, div(stone.digits, 2)))
         right = rem(stone.number, Integer.pow(10, div(stone.digits, 2)))

         [%{number: left, digits: digits(left)}, %{number: right, digits: digits(right)}]
       end},
      {fn _stone -> true end,
       fn stone ->
         new_number = stone.number * 2024
         %{stone | number: new_number, digits: digits(new_number)}
       end}
    ]
  end

  defp digits(num), do: length(Integer.digits(num))

  # @doc """
  # iex> Day11.part2("update or delete me")
  # "update or delete me"
  # """
  # def part2(input) do
  #   input
  # end

  def parse_input(input) do
    input
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def part1_verify, do: input() |> parse_input() |> part1(25) |> length()
  # def part2_verify, do: input() |> parse_input() |> part2()
end
