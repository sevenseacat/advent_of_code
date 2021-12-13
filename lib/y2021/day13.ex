defmodule Y2021.Day13 do
  use Advent.Day, no: 13

  @doc """
  iex> Day13.part1({[{6,10},{0,14},{9,10},{0,3},{10,4},{4,11},{6,0},{6,12},{4,1},{0,13},{10,12},
  ...> {3,4},{3,0},{8,4},{1,10},{2,14},{8,10},{9,0}], [{"y",7},{"x",5}]})
  17
  """
  def part1({points, [fold | _folds]}) do
    fold(points, [fold])
    |> length
  end

  defp fold(points, []), do: points

  defp fold(points, [fold | folds]) do
    points
    |> Enum.map(fn point -> flip_point(point, fold) end)
    |> Enum.uniq()
    |> fold(folds)
  end

  defp flip_point({x, y}, {"x", pos}), do: {flip(x, pos), y}
  defp flip_point({x, y}, {"y", pos}), do: {x, flip(y, pos)}

  defp flip(coord, line) when coord < line, do: coord
  defp flip(coord, line), do: line - (coord - line)

  @doc """
  iex> Day13.parse_input("6,10\\n0,14\\n9,10\\n0,3\\n10,4\\n\\nfold along y=7\\nfold along x=5")
  {[{6,10},{0,14},{9,10},{0,3},{10,4}], [{"y",7},{"x",5}]}
  """
  def parse_input(input) do
    [points, folds] = String.split(input, "\n\n", trim: true)
    {parse_points(points), parse_folds(folds)}
  end

  defp parse_points(points) do
    points
    |> String.split("\n")
    |> Enum.map(fn point ->
      [row, col] = String.split(point, ",")
      {String.to_integer(row), String.to_integer(col)}
    end)
  end

  defp parse_folds(folds) do
    folds
    |> String.split("\n")
    |> Enum.map(fn <<"fold along ", axis::binary-1, "=", pos::binary>> ->
      {axis, String.to_integer(pos)}
    end)
  end

  def part1_verify, do: input() |> parse_input() |> part1()
end
