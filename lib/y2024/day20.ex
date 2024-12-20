defmodule Y2024.Day20 do
  use Advent.Day, no: 20

  alias Advent.PathGrid

  def parts(input, cheat_size) do
    input
    |> cheats(cheat_size)
    |> Enum.reduce(0, fn {saving, count}, acc ->
      if saving >= 100, do: acc + count, else: acc
    end)
  end

  def cheats({graph, from, to}, max_cheat_size) do
    # The default path through the grid takes *every floor space*. Use this
    # to our advantage.
    baseline = Graph.get_shortest_path(graph, from, to)

    map =
      baseline
      |> Enum.with_index()
      |> Map.new()

    cheat_options =
      for row <- -max_cheat_size..max_cheat_size,
          col <- -max_cheat_size..max_cheat_size,
          abs(row) + abs(col) <= max_cheat_size,
          do: {row, col}

    # For each step in the path, see what happens if we knock out walls around it
    # and skip ahead in the path
    Enum.flat_map(baseline, fn {row, col} ->
      from_index = Map.get(map, {row, col})

      Enum.map(cheat_options, fn {o_row, o_col} ->
        to_index = Map.get(map, {row + o_row, col + o_col})

        cond do
          to_index == nil ->
            nil

          to_index < from_index ->
            nil

          true ->
            # This will be the saving of time - 2 is the length of the shortcut
            to_index - from_index - abs(o_row) - abs(o_col)
        end
      end)
      |> Enum.reject(&(&1 == nil || &1 == 0))
    end)
    |> Enum.frequencies()
  end

  def parse_input(input) do
    grid = PathGrid.new(input)
    from = Enum.find(grid.units, &(&1.identifier == "S")) |> Map.get(:position)
    to = Enum.find(grid.units, &(&1.identifier == "E")) |> Map.get(:position)

    {grid.graph, from, to}
  end

  def part1_verify, do: input() |> parse_input() |> parts(2)
  def part2_verify, do: input() |> parse_input() |> parts(20)
end
