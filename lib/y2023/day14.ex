defmodule Y2023.Day14 do
  use Advent.Day, no: 14

  alias Advent.PathGrid

  def part1(%{graph: graph, units: units}) do
    max_coord = PathGrid.size(graph)

    units
    |> roll_all(:north, graph, max_coord)
    |> to_score(max_coord)
  end

  def part2(%{graph: graph, units: units}) do
    max_coord = PathGrid.size(graph)
    max_cycle = 1_000_000_000

    # There will be a repeat after a given number of cycles - use that to skip forward
    units
    |> spin_all(graph, max_coord, 0, %{})
    # Now we can work out what the max_cycle unit list would be
    |> at_max_cycles(max_cycle)
    |> to_score(max_coord)
  end

  defp at_max_cycles({first, second, cache}, max_cycle) do
    target_cycle = fast_forward(max_cycle, second, second - first) + 1

    Enum.find(cache, fn {_key, cycle} -> cycle == target_cycle end)
    |> elem(0)
  end

  defp fast_forward(max_cycle, cycle, increment) do
    if cycle > max_cycle do
      increment - (cycle - max_cycle)
    else
      fast_forward(max_cycle, cycle + increment, increment)
    end
  end

  defp spin_all(units, graph, max_coord, current_cycle, cache) do
    dbg(current_cycle)
    units = spin(units, graph, max_coord)

    if loop = Map.get(cache, units) do
      {loop, current_cycle, cache}
    else
      spin_all(units, graph, max_coord, current_cycle + 1, Map.put(cache, units, current_cycle))
    end
  end

  defp to_score(units, {max_row, _}) do
    units
    |> Enum.map(fn {row, _col} -> max_row - row + 1 end)
    |> Enum.sum()
  end

  defp spin(units, graph, max_coord) do
    units
    |> roll_all(:north, graph, max_coord)
    |> roll_all(:west, graph, max_coord)
    |> roll_all(:south, graph, max_coord)
    |> roll_all(:east, graph, max_coord)
  end

  defp roll_all(units, direction, graph, max_coord) do
    units = keyed_map(units)
    sort_dir = if direction in [:north, :west], do: :asc, else: :desc

    units
    |> Enum.sort_by(
      fn {_key, {row, col}} ->
        if direction in [:east, :west], do: col, else: row
      end,
      sort_dir
    )
    |> Enum.reduce(units, fn unit, units ->
      roll(direction, unit, units, graph, max_coord)
    end)
    |> Map.values()
  end

  def roll(direction, {_index, {row, col}} = unit, units, graph, max_coord) do
    case direction do
      :north -> do_roll(unit, units, graph, row, 0, :row, max_coord)
      :south -> do_roll(unit, units, graph, row, elem(max_coord, 0) + 1, :row, max_coord)
      :east -> do_roll(unit, units, graph, col, elem(max_coord, 1) + 1, :col, max_coord)
      :west -> do_roll(unit, units, graph, col, 0, :col, max_coord)
    end
  end

  defp do_roll({index, unit}, units, graph, actual_value, end_value, direction, max_coord) do
    # IO.puts("=== rolling #{inspect(unit)}")
    range = first_value(actual_value, end_value)..end_value

    new_value =
      Enum.reduce_while(range, nil, fn value, _ ->
        coord = coord(value, unit, direction)
        # IO.puts("checking #{inspect(coord)}")

        if PathGrid.floor?(graph, coord) && !Enum.find(units, fn {_, unit} -> unit == coord end) do
          {:cont, value + range.step}
        else
          {:halt, value - range.step}
        end
      end)

    # it can't roll off the grid
    new_value = on_grid(max_coord, new_value, direction)

    Map.update!(units, index, fn unit -> coord(new_value, unit, direction) end)
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
    # It's not reeeeally a PathGrid but its an easy way to get all the units
    # and coords and stuff
    input
    |> PathGrid.new()
    |> Map.update!(:units, fn units ->
      Enum.map(units, & &1.position)
    end)
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  # def part2_verify, do: input() |> parse_input() |> part2()
end
