defmodule Y2022.Day08 do
  use Advent.Day, no: 08

  def part1(input) do
    {max_row, max_col} = Map.keys(input) |> Enum.max()

    invisible_count =
      input
      |> Enum.reject(&edge_of_grid?(&1, {max_row, max_col}))
      |> Enum.filter(fn {{row, col}, height} ->
        Enum.any?(1..(col - 1), &taller?({row, &1}, height, input)) &&
          Enum.any?((col + 1)..max_col, &taller?({row, &1}, height, input)) &&
          Enum.any?(1..(row - 1), &taller?({&1, col}, height, input)) &&
          Enum.any?((row + 1)..max_row, &taller?({&1, col}, height, input))
      end)
      |> length

    map_size(input) - invisible_count
  end

  defp edge_of_grid?({{row, col}, _height}, {max_row, max_col}) do
    row == 1 || row == max_row || col == 1 || col == max_col
  end

  defp taller?(coord, treehouse, map) do
    Map.get(map, coord) >= treehouse
  end

  def part2(input) do
    max = Map.keys(input) |> Enum.max()

    input
    |> Enum.map(&{&1, scenic_score(&1, input, max)})
    |> Enum.max_by(&elem(&1, 1))
    |> elem(1)
  end

  def scenic_score({{row, col}, treehouse}, map, {max_row, max_col}) do
    up = Enum.map((row - 1)..1, &{&1, col})
    down = Enum.map((row + 1)..max_row, &{&1, col})
    left = Enum.map((col - 1)..1, &{row, &1})
    right = Enum.map((col + 1)..max_col, &{row, &1})

    [up, down, left, right]
    |> Enum.map(fn direction ->
      shorter_count = Enum.take_while(direction, &(!taller?(&1, treehouse, map))) |> length

      # If there are more trees in that direction than are shorter than the treehouse,
      # then add one for the tree blocking the treehouse
      if shorter_count == length(direction), do: shorter_count, else: shorter_count + 1
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
