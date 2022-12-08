defmodule Y2022.Day08 do
  use Advent.Day, no: 08

  def part1(input) do
    {max_row, max_col} = Map.keys(input) |> Enum.max()

    invisible_count =
      input
      |> Enum.reject(fn {{row, col}, _height} ->
        row == 1 || row == max_row || col == 1 || col == max_col
      end)
      |> Enum.filter(fn {{row, col}, height} ->
        Enum.any?(1..(col - 1), fn maybe_col ->
          Map.get(input, {row, maybe_col}) >= height
        end) &&
          Enum.any?((col + 1)..max_col, fn maybe_col ->
            Map.get(input, {row, maybe_col}) >= height
          end) &&
          Enum.any?(1..(row - 1), fn maybe_row ->
            Map.get(input, {maybe_row, col}) >= height
          end) &&
          Enum.any?((row + 1)..max_row, fn maybe_row ->
            Map.get(input, {maybe_row, col}) >= height
          end)
      end)
      |> length

    map_size(input) - invisible_count
  end

  def part2(input) do
    input
    |> Enum.map(&{&1, scenic_score(&1, input)})
    |> Enum.max_by(&elem(&1, 1))
    |> elem(1)
  end

  def scenic_score({{row, col}, treehouse}, map) do
    {max_row, max_col} = Map.keys(map) |> Enum.max()

    up = Enum.map((row - 1)..1, &Map.get(map, {&1, col}))
    down = Enum.map((row + 1)..max_row, &Map.get(map, {&1, col}))
    left = Enum.map((col - 1)..1, &Map.get(map, {row, &1}))
    right = Enum.map((col + 1)..max_col, &Map.get(map, {row, &1}))

    [up, down, left, right]
    |> Enum.map(fn heights ->
      list = Enum.take_while(heights, fn maybe_height -> maybe_height < treehouse end)
      length = length(list)

      # If there are more trees in that direction than are shorter than the treehouse,
      # then add one for the tree blocking the treehouse
      if length == length(heights), do: length, else: length + 1
    end)
    |> Enum.reduce(&Kernel.*/2)
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.reduce({%{}, 1}, &parse_row/2)
    |> elem(0)
  end

  defp parse_row(row, {map, row_num}) do
    map =
      row
      |> String.graphemes()
      |> Enum.reduce({map, 1}, fn char, {map, col_num} ->
        {Map.put(map, {row_num, col_num}, String.to_integer(char)), col_num + 1}
      end)
      |> elem(0)

    {map, row_num + 1}
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  def part2_verify, do: input() |> parse_input() |> part2()
end
