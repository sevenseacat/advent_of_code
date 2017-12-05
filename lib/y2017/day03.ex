defmodule Y2017.Day03 do
  use Advent.Day, no: 03

  alias Y2017.Day03.{Board, Coordinate}

  @puzzle_input 277_678

  @doc """
  iex> Day03.part1(1)
  0

  iex> Day03.part1(12)
  3

  iex> Day03.part1(23)
  2

  iex> Day03.part1(1024)
  31
  """
  def part1(input) when is_integer(input) do
    input
    |> Board.build(fn num -> fn _, _ -> num + 1 end end)
    |> calculate_distance
  end

  @doc """
  This contains a total hack, with exceptions as control flow.
  The reason for this is that the input figure will try to calculate a board of that size, and
  larger boards are exponentially larger to generate (due to the formula for calculating the
  coordinate value).
  We don't want a board of that size - we want to generate board data until the value exceeds the
  input - and I don't know of any other way to break generation early. So here we go.

  iex> Day03.part2(10)
  %Coordinate{x: -1, y: -1, value: 11}

  iex> Day03.part2(50)
  %Coordinate{x: 2, y: 0, value: 54}

  iex> Day03.part2(100)
  %Coordinate{x: 1, y: 2, value: 122}

  iex> Day03.part2(200)
  %Coordinate{x: -2, y: 1, value: 304}
  """
  def part2(input) when is_integer(input) do
    try do
      input
      |> Board.build(fn _ ->
        fn {x, y} = position, coords ->
          val = calculate_coordinate_value(position, coords)

          case val > input do
            false -> val
            true -> raise RuntimeError, message: %Coordinate{x: x, y: y, value: val}
          end
        end
      end)
    rescue
      e in RuntimeError -> e.message
    end
  end

  @doc """
  Given an {x,y} coordinate, determine the value for it based on all the calculated coordinates so far.
  iex> Day03.calculate_coordinate_value({-1, 0}, [
  ...>  %Coordinate{x: 0, y: 0, value: 1}, %Coordinate{x: 1, y: 0, value: 1}, %Coordinate{x: 1, y: 1, value: 2},
  ...>  %Coordinate{x: 0, y: 1, value: 4}, %Coordinate{x: -1, y: 1, value: 5}])
  10

  iex> Day03.calculate_coordinate_value({0, -1}, [
  ...>  %Coordinate{x: 0, y: 0, value: 1}, %Coordinate{x: 1, y: 0, value: 1}, %Coordinate{x: 1, y: 1, value: 2},
  ...>  %Coordinate{x: 0, y: 1, value: 4}, %Coordinate{x: -1, y: 1, value: 5}, %Coordinate{x: -1, y: 0, value: 10},
  ...>  %Coordinate{x: -1, y: -1, value: 11}])
  23
  """
  def calculate_coordinate_value({x, y}, coords) do
    # Each coordinate has eight possible values which must be summed up... but there will be a maximum of 4.
    coords
    |> find_coordinates([
      {x + 1, y},
      {x + 1, y + 1},
      {x, y + 1},
      {x - 1, y + 1},
      {x - 1, y},
      {x - 1, y - 1},
      {x, y - 1},
      {x + 1, y - 1}
    ])
    |> Enum.map(& &1.value)
    |> Enum.sum()
  end

  defp calculate_distance([%Coordinate{x: x, y: y} | _]), do: abs(x) + abs(y)

  defp find_coordinates(all_coords, to_find) do
    all_coords
    |> Stream.filter(fn coordinate -> Enum.member?(to_find, {coordinate.x, coordinate.y}) end)
    |> Enum.take(4)
  end

  def part1_verify, do: part1(@puzzle_input)
  def part2_verify, do: part2(@puzzle_input) |> Map.get(:value)
end
