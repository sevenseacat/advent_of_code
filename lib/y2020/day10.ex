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
    sorted = Enum.sort(input)

    optional_voltage_differentials(Graph.new(), sorted)
    |> Graph.Pathfinding.all(0, Enum.max(input))
    |> length
  end

  defp optional_voltage_differentials(graph, [a, b, c]) do
    graph
    |> compare(b, a)
    |> compare(c, a)
    |> compare(c, b)
  end

  defp optional_voltage_differentials(graph, [a, b, c, d | rest]) do
    graph
    |> compare(a, 0)
    |> compare(b, 0)
    |> compare(c, 0)
    |> compare(b, a)
    |> compare(c, a)
    |> compare(d, a)
    |> optional_voltage_differentials([b, c, d | rest])
  end

  defp compare(graph, b, a) do
    if b - a <= 3 do
      Graph.add_edge(graph, a, b)
    else
      graph
    end
  end

  # 1 2 3 5 8 13 21 34 55 89 144 233 377 610 987 1597 2584 4181 6765 10946 17711 (21)

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
