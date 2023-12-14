defmodule Y2023.Day14 do
  use Advent.Day, no: 14

  alias Advent.PathGrid

  def part1(%{graph: graph, units: units}) do
    max_coord = PathGrid.size(graph)
    units = keyed_map(units)

    units
    |> Enum.sort_by(fn {_key, %{position: {row, _col}}} -> row end)
    |> Enum.reduce(units, fn unit, units ->
      roll_north(unit, units, graph, max_coord)
    end)
    |> to_score(max_coord)
  end

  # @doc """
  # iex> Day14.part2("update or delete me")
  # "update or delete me"
  # """
  # def part2(input) do
  #   input
  # end

  defp to_score(units, {max_row, _}) do
    units
    |> Enum.map(fn {_, %{position: {row, _col}}} ->
      max_row - row + 1
    end)
    |> Enum.sum()
  end

  defp roll_north({index, unit}, units, graph, max_coord) do
    {row, _col} = unit.position

    roll({index, unit}, units, graph, row, 1, :row, max_coord)
  end

  defp roll({index, unit}, units, graph, actual_value, end_value, direction, max_coord) do
    if actual_value == end_value do
      # can't move it
      units
    else
      # can move it
      new_value =
        Enum.reduce_while(first_value(actual_value, end_value)..end_value, nil, fn value, _ ->
          coord = coord(value, unit.position, direction)

          if PathGrid.floor?(graph, coord) &&
               !Enum.any?(units, fn {_, unit} -> unit.position == coord end) do
            {:cont, value - 1}
          else
            {:halt, value + 1}
          end
        end)

      # it can't roll off the grid
      new_value = on_grid(max_coord, new_value, direction)

      Map.update!(units, index, fn unit ->
        %{unit | position: coord(new_value, unit.position, direction)}
      end)
    end
  end

  defp on_grid({row, col}, value, dir) do
    # This is a clamp but clamp doesnt exist in the stdlib
    max = if dir == :row, do: row, else: col
    max(1, value) |> min(max)
  end

  defp first_value(one, two) when one < two, do: one + 1
  defp first_value(one, two) when one > two, do: one - 1

  defp coord(val, {row, _col}, :col), do: {row, val}
  defp coord(val, {_row, col}, :row), do: {val, col}

  defp keyed_map(list) do
    list
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {item, index}, map ->
      Map.put(map, index, item)
    end)
  end

  def parse_input(input) do
    # It's not reeeeally a PathGrid (maybe it will be for part 2!)
    # but its an easy way to get all the units and coords and stuff
    PathGrid.new(input)
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  # def part2_verify, do: input() |> parse_input() |> part2()
end
