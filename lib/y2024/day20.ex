defmodule Y2024.Day20 do
  use Advent.Day, no: 20

  alias Advent.PathGrid

  def part1(input) do
    input
    |> cheats
    |> Enum.reduce(0, fn {saving, count}, acc ->
      if saving >= 100, do: acc + count, else: acc
    end)
  end

  # @doc """
  # iex> Day20.part2("update or delete me")
  # "update or delete me"
  # """
  # def part2(input) do
  #   input
  # end

  def cheats({graph, from, to}) do
    # The default path through the grid takes *every floor space*. Use this
    # to our advantage.
    baseline = Graph.get_shortest_path(graph, from, to)

    map =
      baseline
      |> Enum.with_index()
      |> Map.new()

    # For each step in the path, see what happens if we knock out walls around it
    # and skip ahead in the path
    Enum.flat_map(baseline, fn {row, col} ->
      from_index = Map.get(map, {row, col})

      Enum.map([{0, -1}, {0, 1}, {-1, 0}, {1, 0}], fn {o_row, o_col} ->
        to_index = Map.get(map, {row + o_row * 2, col + o_col * 2})
        maybe_wall = {row + o_row, col + o_col}

        cond do
          !PathGrid.in_graph?(graph, maybe_wall) ->
            nil

          PathGrid.floor?(graph, maybe_wall) ->
            nil

          to_index == nil ->
            nil

          to_index < from_index ->
            nil

          true ->
            # This will be the saving of time - 2 is the length of the shortcut
            to_index - from_index - 2
        end
      end)
      |> Enum.reject(&(&1 == nil))
    end)
    |> Enum.frequencies()
  end

  def parse_input(input) do
    grid = PathGrid.new(input)
    from = Enum.find(grid.units, &(&1.identifier == "S")) |> Map.get(:position)
    to = Enum.find(grid.units, &(&1.identifier == "E")) |> Map.get(:position)

    {grid.graph, from, to}
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  # def part2_verify, do: input() |> parse_input() |> part2()
end
