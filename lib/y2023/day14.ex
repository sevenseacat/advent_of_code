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
    target_cycle = fast_forward(max_cycle, second, second - first) + first - 1

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
    units = spin(units, graph, max_coord) |> Enum.sort()

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
    sort_dir = if direction in [:north, :west], do: :asc, else: :desc

    units
    |> Enum.sort_by(
      fn {row, col} ->
        if direction in [:east, :west], do: col, else: row
      end,
      sort_dir
    )
    |> Enum.map(fn unit -> roll(direction, unit, graph, max_coord) end)
    |> stack(stack_offset(direction))
  end

  # Roll rocks as far as they can go, ignoring the presence of other rollable rocks
  def roll(direction, {row, col} = unit, graph, max_coord) do
    case direction do
      :north -> do_roll(unit, graph, row, 0, :row, max_coord)
      :south -> do_roll(unit, graph, row, elem(max_coord, 0) + 1, :row, max_coord)
      :east -> do_roll(unit, graph, col, elem(max_coord, 1) + 1, :col, max_coord)
      :west -> do_roll(unit, graph, col, 0, :col, max_coord)
    end
  end

  defp stack_offset(:north), do: {1, 0}
  defp stack_offset(:south), do: {-1, 0}
  defp stack_offset(:east), do: {0, -1}
  defp stack_offset(:west), do: {0, 1}

  defp do_roll(unit, graph, actual_value, end_value, direction, max_coord) do
    # IO.puts("=== rolling #{inspect(unit)}")
    range = first_value(actual_value, end_value)..end_value

    new_value =
      Enum.reduce_while(range, nil, fn value, _ ->
        coord = coord(value, unit, direction)
        # IO.puts("checking #{inspect(coord)}")

        if PathGrid.floor?(graph, coord) do
          {:cont, value + range.step}
        else
          {:halt, value - range.step}
        end
      end)

    # it can't roll off the grid
    new_value = on_grid(max_coord, new_value, direction)
    coord(new_value, unit, direction)
  end

  # Rollable rocks may have all rolled to the same coord - re-stack the ones at
  # the same coord in the right direction
  # eg. [[1,1], [1,1]], :north -> [[1,1], [2,1]]
  #     [[2,2], [2,2]], :east -> [[2,2], [2,1]]
  def stack(list, {o_row, o_col}) do
    list
    |> Enum.group_by(& &1)
    |> Enum.reduce([], fn
      {_, [coord]}, acc ->
        [coord | acc]

      {_, [{row, col} | _] = list}, acc ->
        Enum.reduce(0..(length(list) - 1), acc, fn i, acc ->
          [{row + i * o_row, col + i * o_col} | acc]
        end)
    end)
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
  def part2_verify, do: input() |> parse_input() |> part2()
end
