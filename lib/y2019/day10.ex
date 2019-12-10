defmodule Y2019.Day10 do
  use Advent.Day, no: 10

  def part1(input) do
    set = parse_input(input)

    set
    |> Enum.map(fn coord -> {coord, seen_count(set, coord)} end)
    |> Enum.max_by(fn {_, seen} -> seen end)
  end

  # How many asteroids can be seen from a given asteroid position?
  def seen_count(set, coord) do
    Enum.count(set, fn possible -> seen_from?(coord, possible, set) end) - 1
  end

  def seen_from?(coord, coord, _set), do: true

  # https://math.stackexchange.com/questions/497327/find-point-on-line-that-has-integer-coordinates
  def seen_from?({x1, y1}, {x2, y2}, set) do
    # Slope of the line
    points =
      case x2 - x1 do
        # Asymptote - points are straight up/down the line
        0 ->
          Enum.map(y1..y2, fn y -> {x1, y} end)

        # Sloping line - iterate over the x coords, calculate y coords, filter out non-integers
        m ->
          m = (y2 - y1) / m

          Enum.map(x1..x2, fn x ->
            y = m * (x - x1) + y1
            {x, y}
          end)
          |> Enum.filter(fn {_x, y} -> y == trunc(y) end)
          |> Enum.map(fn {x, y} -> {x, trunc(y)} end)
      end
      |> MapSet.new()
      |> MapSet.difference(MapSet.new([{x1, y1}, {x2, y2}]))

    Enum.all?(points, fn {x, y} ->
      !MapSet.member?(set, {x, y})
    end)
  end

  # Input gets parsed into a MapSet of co-ordinates that have asteroids in them.
  def parse_input(input) do
    input
    |> String.split("\n")
    |> Enum.reduce({MapSet.new(), 0}, &parse_row/2)
    |> elem(0)
  end

  defp parse_row(row, {set, row_no}) do
    {set, _} =
      row
      |> String.codepoints()
      |> Enum.reduce({set, 0}, fn coord, {set, col_no} ->
        set =
          case coord do
            "." ->
              set

            "#" ->
              MapSet.put(set, {col_no, row_no})
          end

        {set, col_no + 1}
      end)

    {set, row_no + 1}
  end

  def part1_verify, do: input() |> part1() |> elem(1)
end
