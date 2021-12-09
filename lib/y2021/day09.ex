defmodule Y2021.Day09 do
  use Advent.Day, no: 9

  def part1(input) do
    input
    |> find_low_points()
    |> Enum.map(fn {_coord, num} -> num + 1 end)
    |> Enum.sum()
  end

  def find_low_points(input) do
    Enum.filter(input, fn {{row, col}, val} ->
      Enum.all?([{row - 1, col}, {row + 1, col}, {row, col - 1}, {row, col + 1}], fn coord ->
        !Map.has_key?(input, coord) || Map.get(input, coord) > val
      end)
    end)
    |> Enum.sort()
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
end
