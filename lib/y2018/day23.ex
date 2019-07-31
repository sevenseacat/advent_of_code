defmodule Y2018.Day23 do
  use Advent.Day, no: 23

  @row_regex ~r/pos=<(?<x>-?\d+),(?<y>-?\d+),(?<z>-?\d+)>, r=(?<r>\d+)/

  @doc """
  iex> Day23.part1([%{x: 0, y: 0, z: 0, r: 4}, %{x: 1, y: 0, z: 0, r: 1},
  ...>   %{x: 4, y: 0, z: 0, r: 3}, %{x: 0, y: 2, z: 0, r: 1},
  ...>   %{x: 0, y: 5, z: 0, r: 3}, %{x: 0, y: 0, z: 3, r: 1},
  ...>   %{x: 1, y: 1, z: 1, r: 1}, %{x: 1, y: 1, z: 2, r: 1},
  ...>   %{x: 1, y: 3, z: 1, r: 1}])
  {%{r: 4, x: 0, y: 0, z: 0}, 7}
  """
  def part1(bots) do
    best_bot = Enum.max_by(bots, fn %{r: r} -> r end)

    {best_bot, Enum.count(bots, fn bot -> within_radius?(best_bot, bot) end)}
  end

  @doc """
  iex> Day23.part2([%{x: 10, y: 12, z: 12, r: 2}, %{x: 12, y: 14, z: 12, r: 2},
  ...>   %{x: 16, y: 12, z: 12, r: 4}, %{x: 14, y: 14, z: 14, r: 6},
  ...>   %{x: 50, y: 50, z: 50, r: 200}, %{x: 10, y: 10, z: 10, r: 5}])
  36
  """
  def part2(bots) do
    {%{x: min_x}, %{x: max_x}} = Enum.min_max_by(bots, fn %{x: x} -> x end)
    {%{y: min_y}, %{y: max_y}} = Enum.min_max_by(bots, fn %{y: y} -> y end)
    {%{z: min_z}, %{z: max_z}} = Enum.min_max_by(bots, fn %{z: z} -> z end)

    {x, y, z} = do_part2(bots, {min_x, max_x}, {min_y, max_y}, {min_z, max_z}, 10_000_000)
    x + y + z
  end

  # Instead of iterating over all of the individual points from eg. -1000000000
  # to 100000000, break it down into a bigger box by dividing all of the values
  # by a given factor
  # Working out which point is correct from -100 to 100 is easy, and then you can
  # decrease the factor to find out which point inside that sub-box is correct
  # Keep decreasing the factor until it's zero, in which case you have your final
  # answer!
  defp do_part2(_, {x, _}, {y, _}, {z, _}, 0), do: {x, y, z}

  defp do_part2(bots, {min_x, max_x}, {min_y, max_y}, {min_z, max_z}, factor) do
    {{x, y, z}, _, _} =
      Enum.reduce(div(min_x, factor)..div(max_x, factor), {nil, 0, 0}, fn x, x_acc ->
        Enum.reduce(div(min_y, factor)..div(max_y, factor), x_acc, fn y, y_acc ->
          Enum.reduce(div(min_z, factor)..div(max_z, factor), y_acc, fn z,
                                                                        {_coord, distance,
                                                                         bots_in_range} = acc ->
            new_bots = count_bots_in_range({x, y, z}, bots, factor)

            if new_bots > bots_in_range ||
                 (new_bots == bots_in_range && distance_from_zero({x, y, z}) < distance) do
              {{x, y, z}, distance_from_zero({x, y, z}), new_bots}
            else
              acc
            end
          end)
        end)
      end)

    do_part2(
      bots,
      {x * factor, (x + 1) * factor},
      {y * factor, (y + 1) * factor},
      {z * factor, (z + 1) * factor},
      div(factor, 10)
    )
  end

  defp count_bots_in_range({x1, y1, z1}, bots, f) do
    Enum.count(bots, fn %{x: x2, y: y2, z: z2, r: r} ->
      within_radius?(%{x: div(x2, f), y: div(y2, f), z: div(z2, f), r: div(r, f)}, %{
        x: x1,
        y: y1,
        z: z1
      })
    end)
  end

  defp distance_from_zero({x, y, z}), do: abs(x) + abs(y) + abs(z)

  defp within_radius?(%{x: x1, y: y1, z: z1, r: r}, %{x: x2, y: y2, z: z2}) do
    abs(x1 - x2) + abs(y1 - y2) + abs(z1 - z2) <= r
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_row/1)
  end

  defp parse_row(row) do
    string_row = Regex.named_captures(@row_regex, row)
    for {key, val} <- string_row, into: %{}, do: {String.to_atom(key), String.to_integer(val)}
  end

  def part1_verify, do: input() |> parse_input() |> part1() |> elem(1)
  def part2_verify, do: input() |> parse_input() |> part2()
end
