defmodule Y2020.Day09 do
  use Advent.Day, no: 9

  @doc """
  iex> Day09.part1([35, 20, 15, 25, 47, 40, 62, 55, 65, 95, 102, 117, 150, 182,
  ...>             127, 219, 299, 277, 309, 576], 5)
  127
  """
  def part1(input, preamble_length) do
    {preamble, rest} = Enum.split(input, preamble_length)
    find_invalid_input(preamble, rest)
  end

  defp find_invalid_input(preamble, [val | rest]) do
    if is_valid?(preamble, val) do
      find_invalid_input(tl(preamble) ++ [val], rest)
    else
      val
    end
  end

  defp is_valid?(preamble, val) do
    length(for i <- preamble, j <- preamble, i != j, i + j == val, do: {i, j}) > 0
  end

  @doc """
  iex> Day09.part2([35, 20, 15, 25, 47, 40, 62, 55, 65, 95, 102, 117, 150, 182,
  ...>             127, 219, 299, 277, 309, 576], 5)
  {[15, 25, 47, 40], 62}
  """
  def part2(input, preamble_length) do
    invalid = part1(input, preamble_length)
    list = find_invalid_sequence(input, invalid)
    {min, max} = Enum.min_max(list)
    {Enum.reverse(list), min + max}
  end

  defp find_invalid_sequence(input, invalid) do
    {list, result} =
      Enum.reduce_while(input, {[], 0}, fn x, {list, acc} ->
        sum = x + acc

        if sum < invalid do
          {:cont, {[x | list], sum}}
        else
          {:halt, {[x | list], sum}}
        end
      end)

    if result == invalid do
      list
    else
      find_invalid_sequence(tl(input), invalid)
    end
  end

  @doc """
  iex> Day09.parse_input("1\\n2\\n3\\n")
  [1,2,3]
  """
  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def part1_verify, do: input() |> parse_input() |> part1(25)
  def part2_verify, do: input() |> parse_input() |> part2(25) |> elem(1)
end
