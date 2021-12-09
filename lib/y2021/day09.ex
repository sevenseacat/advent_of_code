defmodule Y2021.Day09 do
  use Advent.Day, no: 9

  def part1(input) do
    input
    |> find_low_points()
    |> Enum.map(fn {_coord, num} -> num + 1 end)
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> find_low_points()
    |> Enum.map(&find_basin(&1, input))
    |> Enum.map(&MapSet.size/1)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.reduce(&*/2)
  end

  def find_low_points(input) do
    Enum.filter(input, fn {coord, val} ->
      Enum.all?(adjacent(coord, input), fn {_adj_coord, adj_val} ->
        adj_val == nil || adj_val > val
      end)
    end)
  end

  defp adjacent({row, col}, input) do
    [{row - 1, col}, {row + 1, col}, {row, col - 1}, {row, col + 1}]
    |> Enum.map(fn coord -> {coord, Map.get(input, coord, nil)} end)
  end

  def find_basin(low_point, input), do: do_find_basin([low_point], MapSet.new(), input)

  defp do_find_basin([], seen, _input), do: seen

  defp do_find_basin([{coord, val} = this | rest], seen, input) do
    new_to_check =
      Enum.filter(adjacent(coord, input), fn {_adj_coord, adj_val} ->
        adj_val != nil && adj_val != 9 && adj_val > val
      end)

    do_find_basin(new_to_check ++ rest, MapSet.put(seen, this), input)
  end

  @doc """
  iex> Day09.parse_input("21990\\n39921")
  %{{0,0} => 2, {0,1} => 1, {0,2} => 9, {0,3} => 9, {0,4} => 0, {1,0} => 3, {1,1} => 9, {1,2} => 9, {1,3} => 2, {1,4} => 1}
  """
  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {row_data, row}, acc ->
      row_data
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {col_data, col}, acc ->
        Map.put(acc, {row, col}, String.to_integer(col_data))
      end)
    end)
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  def part2_verify, do: input() |> parse_input() |> part2()
end
