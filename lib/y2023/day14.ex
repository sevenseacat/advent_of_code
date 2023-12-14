defmodule Y2023.Day14 do
  use Advent.Day, no: 14

  alias Advent.PathGrid

  def part1(%{graph: graph, units: units}) do
    {max_row, _max_col} =
      graph
      |> Graph.vertices()
      |> Enum.max_by(fn {row, _col} -> row end)

    units = keyed_map(units)

    units
    |> Enum.sort_by(fn {_key, %{position: {row, _col}}} -> row end)
    |> Enum.reduce(units, fn unit, units ->
      roll_north(unit, units, graph)
    end)
    |> Enum.map(fn {_index, %{position: {row, _col}}} ->
      max_row - row + 1
    end)
    |> Enum.sum()
  end

  # @doc """
  # iex> Day14.part2("update or delete me")
  # "update or delete me"
  # """
  # def part2(input) do
  #   input
  # end

  defp roll_north({index, unit}, units, graph) do
    {row, col} = unit.position

    if row == 1 do
      # can't move it
      units
    else
      # can move it
      new_row =
        Enum.reduce_while((row - 1)..1, row, fn new_row, _max_roll ->
          if PathGrid.floor?(graph, {new_row, col}) &&
               !Enum.any?(units, fn {_, unit} -> unit.position == {new_row, col} end) do
            {:cont, new_row - 1}
          else
            {:halt, new_row + 1}
          end
        end)

      # it can't roll off the grid
      new_row = if new_row == 0, do: 1, else: new_row

      Map.update!(units, index, fn unit -> %{unit | position: {new_row, col}} end)
    end
  end

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
