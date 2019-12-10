defmodule Y2019.Day10 do
  use Advent.Day, no: 10

  def part1(set) do
    set
    |> Enum.map(fn coord -> {coord, seen_count(set, coord)} end)
    |> Enum.max_by(fn {_, seen} -> seen end)
  end

  def part2(set) do
    {x, y} =
      set
      |> run_laser_simulation(MapSet.size(set) - 1)
      |> Enum.at(199)

    x * 100 + y
  end

  def run_laser_simulation(set, times \\ 1) do
    laser = part1(set) |> elem(0)

    Enum.reduce(1..times, {set, -0.000000001, []}, fn _count, {set, angle, already_gone} ->
      {new_set, new_angle, destroyed} = fire_laser(laser, angle, set)
      {new_set, new_angle, [destroyed | already_gone]}
    end)
    |> elem(2)
    |> Enum.reverse()
  end

  defp fire_laser({x1, y1}, angle, set) do
    targets = seen_asteroids(set, {x1, y1})

    targets_and_angles =
      Enum.map(targets, fn {x2, y2} ->
        # https://math.stackexchange.com/a/2587852 converted to degrees in the position we want
        {{x2, y2}, :math.atan2(y2 - y1, x2 - x1) * 180 / :math.pi() + 90}
      end)

    {pos, angle} = find_best_target({x1, y1}, targets_and_angles, angle)
    {MapSet.delete(set, pos), angle, pos}
  end

  defp find_best_target({x1, y1}, targets, angle) do
    # To cover rotation past 360, duplicate the set and give them angles of +360
    possibles =
      (targets ++ Enum.map(targets, fn {coord, angle} -> {coord, angle + 360} end))
      |> Enum.filter(fn {_, a} -> a > angle end)

    winning_angle = Enum.min_by(possibles, fn {_, angle} -> angle end) |> elem(1)

    winning_target =
      possibles
      |> Enum.filter(fn {_, angle} -> angle == winning_angle end)
      |> Enum.min_by(fn {{x2, y2}, _} -> abs(x1 - x2) + abs(y1 - y2) end)
      |> elem(0)

    winning_angle = if winning_angle >= 360, do: winning_angle - 360, else: winning_angle
    winning_angle = if winning_angle >= 360, do: winning_angle - 360, else: winning_angle

    {winning_target, winning_angle}
  end

  # How many asteroids can be seen from a given asteroid position?
  def seen_count(set, coord) do
    Enum.count(seen_asteroids(set, coord))
  end

  def seen_asteroids(set, coord) do
    Enum.filter(set, fn possible -> seen_from?(coord, possible, set) end) -- [coord]
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

  def part1_verify, do: input() |> parse_input() |> part1() |> elem(1)
  def part2_verify, do: input() |> parse_input() |> part2()
end
