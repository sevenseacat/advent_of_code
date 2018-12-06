defmodule Y2018.Day06 do
  use Advent.Day, no: 6

  @markers ~w/a b c d e f g h i j k l m n o p q r s t u v w x y z ! @ # $ % ^ & * ( ) - _ + = : ; < > , ? A B C S T F R N M P |/

  @doc """
  iex> Day06.part1("1, 1\\n1, 6\\n8, 3\\n3, 4\\n5, 5\\n8, 9")
  {{5, 5}, 17}
  """
  def part1(input) do
    points = parse_input(input)

    {mins, maxes} = bounds_of_grid(points)
    grid = manhattan_grid(points, mins, maxes)

    {point, count} =
      points
      |> Stream.reject(fn point -> infinite_area?(grid, point, mins, maxes) end)
      |> Stream.map(fn point -> {point, Map.get(grid, point) |> length} end)
      |> Enum.max_by(fn {_, count} -> count end)

    # display_grid(grid, points, mins, maxes, point)

    {point, count}
  end

  @doc """
  iex> Day06.part2("1, 1\\n1, 6\\n8, 3\\n3, 4\\n5, 5\\n8, 9", 32)
  16
  """
  def part2(input, score_limit) do
    points = parse_input(input)

    {mins, maxes} = bounds_of_grid(points)

    all_coordinates(mins, maxes)
    |> Enum.count(fn coord -> safety_score(coord, points) < score_limit end)
  end

  defp bounds_of_grid(points) do
    {{min_x, _}, {max_x, _}} = Enum.min_max_by(points, fn {x, _} -> x end)
    {{_, min_y}, {_, max_y}} = Enum.min_max_by(points, fn {_, y} -> y end)

    {{min_x, min_y}, {max_x, max_y}}
  end

  @doc """
  iex> points = [{1, 1}, {1, 6}, {8, 3}, {3, 4}, {5, 5}, {8, 9}]
  iex> Day06.safety_score({4, 3}, points)
  30
  """
  def safety_score(coord, points) do
    points
    |> Enum.map(fn point -> manhattan_distance(point, coord) end)
    |> Enum.sum()
  end

  defp manhattan_grid(points, mins, maxes) do
    all_coordinates(mins, maxes)
    |> Enum.reduce(Map.new(), fn coord, acc ->
      owner =
        coord
        |> all_manhattan_distances(points)
        |> Enum.sort_by(fn {_, distance} -> distance end)
        |> get_owning_coord

      Map.update(acc, owner, [coord], &[coord | &1])
    end)
  end

  defp infinite_area?(grid, point, {min_x, min_y}, {max_x, max_y}) do
    grid
    |> Map.get(point)
    |> Enum.any?(fn {x, y} -> x == min_x || x == max_x || y == min_y || y == max_y end)
  end

  defp all_manhattan_distances(coord, points) do
    Enum.map(points, fn point -> {point, manhattan_distance(coord, point)} end)
  end

  defp manhattan_distance({x1, y1}, {x2, y2}), do: abs(x1 - x2) + abs(y1 - y2)

  defp get_owning_coord([{coord, x}, {_, y} | _]) do
    case x == y do
      true -> nil
      false -> coord
    end
  end

  defp all_coordinates({min_x, min_y}, {max_x, max_y}) do
    for x <- min_x..max_x, y <- min_y..max_y, do: {x, y}
  end

  @doc """
  iex> Day06.parse_input("1, 1\\n1, 6\\n8, 3\\n3, 4\\n5, 5\\n8, 9")
  [{1, 1}, {1, 6}, {8, 3}, {3, 4}, {5, 5}, {8, 9}]
  """
  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_coord/1)
  end

  defp parse_coord(coord) do
    [x, y] = String.split(coord, ", ")
    {String.to_integer(x), String.to_integer(y)}
  end

  @doc """
  Debugging function to print out the grid with different characters for different territory.
  Allows a square to be highlighted - finally showing me that my infinite area test was borked.
  """
  def display_grid(map, points, {x1, y1}, {x2, y2}, {highlight_x, highlight_y} \\ {0, 0}) do
    IO.puts("")

    markers = Enum.zip(points, @markers) |> Enum.into(%{})

    for y <- y1..y2, x <- x1..x2 do
      if x == highlight_x and y == highlight_y do
        "█"
      else
        owner =
          map
          |> Enum.find(fn {_k, vs} -> Enum.member?(vs, {x, y}) end)
          |> elem(0)

        Map.get(markers, owner, ".")
      end
    end
    |> Enum.chunk_every(x2 - x1 + 1)
    |> Enum.map(&Enum.join/1)
    |> Enum.map(&IO.puts/1)
  end

  def part1_verify, do: input() |> part1() |> elem(1)
  def part2_verify, do: input() |> part2(10000)
end
