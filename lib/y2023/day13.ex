defmodule Y2023.Day13 do
  use Advent.Day, no: 13

  alias Advent.Grid

  def part1(input), do: do_parts(input, &reflection/1)
  def part2(input), do: do_parts(input, &smudged_reflection/1)

  defp do_parts(input, method) do
    {verticals, horizontals} =
      input
      |> Enum.map(method)
      |> Enum.split_with(fn {type, _line} -> type == :vertical end)

    sum(verticals) + 100 * sum(horizontals)
  end

  defp sum(list) do
    list
    |> Enum.map(&elem(&1, 1))
    |> Enum.sum()
  end

  def reflection({grid, max_coord}, collect_all? \\ false) do
    horizontal_reflection(grid, max_coord, 1, collect_all?) ||
      vertical_reflection(grid, max_coord, 1, collect_all?)
  end

  def all_reflections({grid, max_coord}) do
    horizontal_reflection(grid, max_coord, 1, true) ++
      vertical_reflection(grid, max_coord, 1, true)
  end

  def smudged_reflection({grid, max_coord}) do
    old_reflection = reflection({grid, max_coord})

    grid
    |> Enum.find_value(fn {coord, key} ->
      grid = Map.replace(grid, coord, invert(key))

      valid_reflections =
        all_reflections({grid, max_coord})
        |> Enum.reject(fn r -> r == old_reflection end)

      if valid_reflections != [] do
        hd(valid_reflections)
      end
    end)
  end

  defp invert("."), do: "#"
  defp invert("#"), do: "."

  defp vertical_reflection(grid, coord, col, collect_all?) do
    reflection(grid, coord, col, :vertical, collect_all?)
  end

  defp horizontal_reflection(grid, {max_row, max_col}, col, collect_all?) do
    for {{row, col}, val} <- grid, into: %{} do
      {{col, row}, val}
    end
    |> reflection({max_col, max_row}, col, :horizontal, collect_all?)
  end

  defp reflection(_grid, {_max_row, max_col}, max_col, _type, true), do: []
  defp reflection(_grid, {_max_row, max_col}, max_col, _type, false), do: nil

  defp reflection(grid, {max_row, max_col}, col, type, collect_all?) do
    to_check = Enum.min([col, max_col - col])

    if valid_reflection?(grid, max_row, col, to_check) do
      if collect_all? do
        [{type, col} | reflection(grid, {max_row, max_col}, col + 1, type, collect_all?)]
      else
        {type, col}
      end
    else
      reflection(grid, {max_row, max_col}, col + 1, type, collect_all?)
    end
  end

  defp valid_reflection?(_grid, _max_row, _col, 0), do: false

  defp valid_reflection?(grid, max_row, col, to_check) do
    Enum.all?(1..to_check, fn check ->
      line(grid, max_row, col - check + 1) == line(grid, max_row, col + check)
    end)
  end

  defp line(grid, max_row, col) do
    Enum.map(1..max_row, fn row -> Map.fetch!(grid, {row, col}) end)
  end

  def parse_input(input) do
    for grid <- String.split(input, "\n\n", trim: true) do
      grid = Grid.new(grid)
      {grid, Grid.size(grid)}
    end
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  def part2_verify, do: input() |> parse_input() |> part2()
end
