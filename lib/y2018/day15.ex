defmodule Y2018.Day15 do
  use Advent.Day, no: 15

  alias Y2018.Day15.Unit

  @unit_types %{"G" => :goblin, "E" => :elf}

  def part1(_input) do
  end

  def parse_input(input) do
    {units, coords, _row} =
      input
      |> String.split("\n", trim: true)
      |> Enum.reduce({[], MapSet.new(), 1}, &parse_row/2)

    sort_units({units, coords})
  end

  defp parse_row(row, {units, coords, row_num}) do
    {units, coords, _col_num} =
      row
      |> String.graphemes()
      |> Enum.reduce({units, coords, 1}, fn char, {units, coords, col_num} ->
        units = parse_unit(char, units, row_num, col_num)
        coords = parse_coord(char, coords, row_num, col_num)
        {units, coords, col_num + 1}
      end)

    {units, coords, row_num + 1}
  end

  defp sort_units({units, coords}) do
    units = Enum.sort_by(units, fn unit -> unit.position end)
    {units, coords}
  end

  defp parse_unit("#", units, _, _), do: units
  defp parse_unit(".", units, _, _), do: units

  defp parse_unit(unit, units, row, col) do
    [%Unit{type: @unit_types[unit], hp: 200, position: {row, col}} | units]
  end

  defp parse_coord("#", coords, _, _), do: coords

  defp parse_coord(_, coords, row, col) do
    MapSet.put(coords, {row, col})
  end
end
