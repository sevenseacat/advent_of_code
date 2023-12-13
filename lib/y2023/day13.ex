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

  def reflection({grid, max_coord}) do
    horizontal_reflection(grid, max_coord, 1) || vertical_reflection(grid, max_coord, 1)
  end

  def smudged_reflection({grid, max_coord}) do
    old_reflection = reflection({grid, max_coord})

    grid
    |> Enum.find_value(fn {coord, key} ->
      grid = Map.replace(grid, coord, invert(key))
      reflection = reflection({grid, max_coord})
      if reflection && old_reflection != reflection, do: reflection
    end)
  end

  defp invert("."), do: "#"
  defp invert("#"), do: "."

  defp vertical_reflection(grid, coord, col) do
    reflection(grid, coord, col, :vertical)
  end

  defp horizontal_reflection(grid, {max_row, max_col}, col) do
    for {{row, col}, val} <- grid, into: %{} do
      {{col, row}, val}
    end
    |> reflection({max_col, max_row}, col, :horizontal)
  end

  defp reflection(_grid, {_max_row, max_col}, max_col, _type), do: nil

  defp reflection(grid, {max_row, max_col}, col, type) do
    to_check = Enum.min([col, max_col - col])

    if to_check > 0 &&
         Enum.all?(1..to_check, fn val ->
           line(grid, max_row, col - val + 1) == line(grid, max_row, col + val)
         end) do
      {type, col}
    else
      reflection(grid, {max_row, max_col}, col + 1, type)
    end
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
  # def part2_verify, do: input() |> parse_input() |> part2()
end
