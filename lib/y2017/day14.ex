defmodule Y2017.Day14 do
  use Advent.Day, no: 14

  alias Y2017.Day10

  @puzzle_input "nbysizxe"

  @doc """
  Testing a 128x128 grid takes way too long - the example uses 8x8.

  iex> Day14.part1("flqrgnkx", 8)
  29
  """
  def part1(input \\ @puzzle_input, size) do
    (size - 1)..0
    |> Enum.to_list()
    |> Stream.map(&calculate_hash(input, &1))
    |> Enum.map(&to_bits(&1, div(size, 4)))
    |> List.flatten()
    |> Enum.sum()
  end

  @doc """
  Same as above, use the 8x8 grid for test purposes. The example in the question's answer is 8, but
  that includes off screen things. When only considering the 8x8 grid, it's 12.

  iex> Day14.part2("flqrgnkx", 8)
  12
  """
  def part2(input \\ @puzzle_input, size) do
    list = Enum.to_list(0..(size - 1))

    list
    |> Stream.map(&calculate_hash(input, &1))
    |> Stream.map(&to_bits(&1, div(size, 4)))
    |> Stream.zip(list)
    |> Enum.reduce([], &convert_to_points(&1, &2, 0))
    |> count_groups(0)
  end

  @doc """
  iex> Day14.to_bits("a0c2017", 7)
  [1, 0, 1, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1]
  """
  def to_bits(string, size) do
    string
    |> String.codepoints()
    |> Enum.take(size)
    |> Enum.map(&bits/1)
    |> List.flatten()
  end

  defp bits(char) do
    case char do
      "0" -> [0, 0, 0, 0]
      "1" -> [0, 0, 0, 1]
      "2" -> [0, 0, 1, 0]
      "3" -> [0, 0, 1, 1]
      "4" -> [0, 1, 0, 0]
      "5" -> [0, 1, 0, 1]
      "6" -> [0, 1, 1, 0]
      "7" -> [0, 1, 1, 1]
      "8" -> [1, 0, 0, 0]
      "9" -> [1, 0, 0, 1]
      "a" -> [1, 0, 1, 0]
      "b" -> [1, 0, 1, 1]
      "c" -> [1, 1, 0, 0]
      "d" -> [1, 1, 0, 1]
      "e" -> [1, 1, 1, 0]
      "f" -> [1, 1, 1, 1]
    end
  end

  defp count_groups([], count), do: count

  defp count_groups([elem | rest], count) do
    {_group, not_adjacent} = split_out_group([elem], [], rest)
    count_groups(not_adjacent, count + 1)
  end

  defp split_out_group([], seen, list), do: {seen, list}

  defp split_out_group([{x, y} | coords], seen, list) do
    possible_adjacent = [{x + 1, y}, {x, y + 1}, {x - 1, y}, {x, y - 1}]
    {adjacent, rest} = Enum.split_with(list, &Enum.member?(possible_adjacent, &1))
    split_out_group(adjacent ++ coords, [{x, y} | seen], rest)
  end

  defp convert_to_points({[], _}, acc, _), do: acc |> Enum.reverse()

  defp convert_to_points({[key | keys], index}, acc, counter) do
    new_acc = if key == 1, do: [{counter, index} | acc], else: acc
    convert_to_points({keys, index}, new_acc, counter + 1)
  end

  defp calculate_hash(input, suffix) do
    Day10.part2("#{input}-#{suffix}")
  end

  def part1_verify, do: part1(128)
  def part2_verify, do: part2(128)
end
