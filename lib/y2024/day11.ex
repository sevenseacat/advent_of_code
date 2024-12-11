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
      # So for each number, store what numbers we pre-compute to replace them with, and a count
      Map.update(acc, num, {replace(num), 1}, fn {replace, count} -> {replace, count + 1} end)
    end)
    |> blink(times)
    |> Enum.map(fn {_num, {_replace, count}} -> count end)
    |> Enum.sum()
  end

  defp blink(input, 0), do: input

  defp blink(input, times) do
    input
    |> Enum.reduce(%{}, fn {num, {to_replace, count}}, acc ->
      # We might be replacing one stone with two, so reduce again
      Enum.reduce(to_replace, acc, fn replace_num, acc ->
        # If this is a number we've already seen, we know what to replace it with already
        replace_with = Map.get(input, replace_num, {nil, 0}) |> elem(0) || replace(replace_num)

        Map.update(acc, replace_num, {replace_with, count}, fn {replace, old_count} ->
          {replace, count + old_count}
        end)
      end)
      |> Map.put_new(num, {to_replace, 0})
    end)
    |> blink(times - 1)
  end

  defp replace(stone) do
    digits = digits(stone)

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

  defp digits(num), do: length(Integer.digits(num))

  def parse_input(input) do
    input
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def part1_verify, do: input() |> parse_input() |> parts(25)
  def part2_verify, do: input() |> parse_input() |> parts(75)
end
