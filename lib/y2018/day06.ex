defmodule Y2018.Day06 do
  use Advent.Day, no: 6

  @ids ~w/a b c d e f g h i j k l m n o p q r s t u v w x y z ! @ # $ % ^ & * ( ) - _ + = : ; < > , ? A B C S T F R N M P |/

  @doc """
  iex> Day06.part1("1, 1\\n1, 6\\n8, 3\\n3, 4\\n5, 5\\n8, 9")
  {{5, 5}, 17}
  """
  def part1(input) do
    points =
      parse_input(input)
      |> Enum.zip(@ids)

    {{{min_x, _}, _}, {{max_x, _}, _}} = Enum.min_max_by(points, fn {{x, _}, _} -> x end)
    {{{_, min_y}, _}, {{_, max_y}, _}} = Enum.min_max_by(points, fn {{_, y}, _} -> y end)

    manhattan_grid = manhattan_grid(points, {min_x, min_y}, {max_x, max_y})

    {{x, y}, count} =
      points
      |> Enum.reject(fn coord ->
        infinite_area?(manhattan_grid, coord, {min_x, min_y}, {max_x, max_y})
      end)
      |> Enum.map(fn {coord, letter} ->
        {coord, Enum.count(manhattan_grid, fn {_, char_letter} -> char_letter == letter end)}
      end)
      |> Enum.sort_by(fn {_, count} -> -count end)
      |> hd

    # display_grid(manhattan_grid, {min_x, min_y}, {max_x, max_y}, {x, y})

    {{x, y}, count}
  end

  defp manhattan_grid(points, mins, maxes) do
    all_coordinates(mins, maxes)
    |> Enum.reduce(%{}, fn coord, acc ->
      owner =
        coord
        |> all_manhattan_distances(points)
        |> Enum.sort_by(fn {_, distance} -> distance end)
        |> get_winning_letter

      Map.put(acc, coord, owner)
    end)
  end

  defp infinite_area?(grid, {_, letter}, {min_x, min_y}, {max_x, max_y}) do
    Enum.any?(grid, fn {{x, y}, grid_letter} ->
      letter == grid_letter && (x == min_x || x == max_x || y == min_y || y == max_y)
    end)
  end

  defp all_manhattan_distances({x, y}, points) do
    # IO.inspect({x, y})

    points
    |> Enum.reduce([], fn {{point_x, point_y}, letter}, acc ->
      [{letter, abs(point_x - x) + abs(point_y - y)} | acc]
    end)
  end

  defp get_winning_letter([{letter, x}, {_, y} | _]) do
    case x == y do
      true -> "."
      false -> letter
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
  def display_grid(map, {x1, y1}, {x2, y2}, {highlight_x, highlight_y}) do
    IO.puts("")

    for y <- y1..y2, x <- x1..x2 do
      if x == highlight_x and y == highlight_y, do: "█", else: Map.get(map, {x, y})
    end
    |> Enum.chunk_every(x2 - x1 + 1)
    |> Enum.map(&Enum.join/1)
    |> Enum.map(&IO.puts/1)
  end

  def part1_verify, do: input() |> part1() |> elem(1)
end