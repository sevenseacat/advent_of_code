defmodule Y2020.Day10 do
  use Advent.Day, no: 10

  @doc """
  iex> Day10.part1([16, 10, 15, 5, 1, 11, 7, 19, 6, 12, 4])
  {7, 5}

  iex> Day10.part1([28, 33, 18, 42, 31, 14, 46, 20, 48, 47, 24, 23, 49, 45, 19,
  ...> 38, 39, 11, 1, 32, 25, 35, 8, 17, 7, 9, 4, 2, 34, 10, 3])
  {22, 10}
  """
  def part1(input) do
    [start | _rest] = sorted = Enum.sort(input)
    voltage_differentials(sorted, {initial(start, 1), initial(start, 3)})
  end

  defp initial(a, a), do: 1
  defp initial(_, _), do: 0

  defp voltage_differentials([_a], {ones, threes}), do: {ones, threes + 1}

  defp voltage_differentials([a, b | rest], {ones, threes}) do
    case b - a do
      1 -> voltage_differentials([b | rest], {ones + 1, threes})
      2 -> voltage_differentials([b | rest], {ones, threes})
      3 -> voltage_differentials([b | rest], {ones, threes + 1})
      _ -> :exit
    end
  end

  @doc """
  iex> Day10.part2([16, 10, 15, 5, 1, 11, 7, 19, 6, 12, 4])
  8

  iex> Day10.part2([28, 33, 18, 42, 31, 14, 46, 20, 48, 47, 24, 23, 49, 45, 19,
  ...> 38, 39, 11, 1, 32, 25, 35, 8, 17, 7, 9, 4, 2, 34, 10, 3])
  19208
  """
  def part2(input) do
    [0 | Enum.sort(input)]
    |> voltage_differentials
    |> Enum.chunk_by(fn v -> v == 1 end)
    |> Enum.reject(fn v -> v == [1] || Enum.all?(v, &(&1 == 3)) end)
    |> Enum.map(&length/1)
    |> Enum.map(&to_permutation_count/1)
    |> Enum.reduce(1, fn x, acc -> x * acc end)
  end

  # this is ***between*** numbers - so a differential of 3, 1, 3 means there's a sequence like 4, 7, 8, 11
  defp voltage_differentials([_a]), do: [3]

  defp voltage_differentials([a, b | rest]) do
    [b - a | voltage_differentials([b | rest])]
  end

  # 3 sequential numbers - 2 different permutations
  # 4 7 8 9 12
  # 4 7   9 12
  defp to_permutation_count(2), do: 2

  # 4 sequential numbers - 4 permutations
  # 4 7 8 9 10 13
  # 4 7   9 10 13
  # 4 7 8   10 13
  # 4 7     10 13
  defp to_permutation_count(3), do: 4

  # 5 sequential numbers - 7 permutations
  # 4 7 8 9 10 11 14
  # 4 7   9 10 11 14
  # 4 7 8   10 11 14
  # 4 7 8 9    11 14
  # 4 7     10 11 14
  # 4 7 8      11 14
  # 4 7   9    11 14
  defp to_permutation_count(4), do: 7

  @doc """
  iex> Day10.parse_input("1\\n2\\n3\\n")
  [1,2,3]
  """
  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def part1_verify do
    {one, two} = input() |> parse_input() |> part1()
    one * two
  end

  def part2_verify, do: input() |> parse_input() |> part2()
end
