defmodule Y2024.Day11 do
  use Advent.Day, no: 11

  @doc """
  iex> Day11.parts([0, 1, 10, 99, 999], 1)
  7

  iex> Day11.parts([125, 17], 1)
  3

  iex> Day11.parts([125, 17], 2)
  4

  iex> Day11.parts([125, 17], 3)
  5

  iex> Day11.parts([125, 17], 4)
  9

  iex> Day11.parts([125, 17], 5)
  13

  iex> Day11.parts([125, 17], 6)
  22
  """
  def parts(input, times \\ 1) do
    input
    |> Enum.reduce(%{}, fn num, acc ->
      # We don't care about the order of stones, we only care about how many of each number we have
      # # So for each number, store what numbers we pre-compute to replace them with, and a count
      Map.update(acc, num, 1, fn count -> count + 1 end)
    end)
    |> blink(times)
    |> Map.values()
    |> Enum.sum()
  end

  defp blink(input, 0), do: input

  defp blink(input, times) do
    input
    |> Enum.reduce(%{}, fn {num, count}, acc ->
      # We might be replacing one stone with two, so reduce again
      Enum.reduce(replace(num), acc, fn replace_num, acc ->
        Map.update(acc, replace_num, count, fn old_count -> count + old_count end)
      end)
    end)
    |> blink(times - 1)
  end

  defp replace(stone) do
    digits = length(Integer.digits(stone))

    replacement_rule =
      Enum.find(replacement_rules(), fn {condition, _} -> condition.(stone, digits) end)
      |> elem(1)

    replacement_rule.(stone, digits)
  end

  defp replacement_rules do
    [
      {fn stone, _digits -> stone == 0 end, fn _stone, _digits -> [1] end},
      {fn _stone, digits -> rem(digits, 2) == 0 end,
       fn stone, digits ->
         left = div(stone, Integer.pow(10, div(digits, 2)))
         right = rem(stone, Integer.pow(10, div(digits, 2)))

         [left, right]
       end},
      {fn _stone, _digits -> true end, fn stone, _digits -> [stone * 2024] end}
    ]
  end

  def parse_input(input) do
    input
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def part1_verify, do: input() |> parse_input() |> parts(25)
  def part2_verify, do: input() |> parse_input() |> parts(75)
end
