defmodule Y2018.Day15 do
  use Advent.Day, no: 15

  alias Y2018.Day15.Unit

  @unit_types %{"G" => :goblin, "E" => :elf}

  def part1(input) do
    input
    |> parse_input
    |> do_part1(0)
  end

  defp do_part1({units, graph}, round_no) do
    IO.inspect(round_no, label: "round no")
    new_units = do_round({units, graph}) |> IO.inspect()
    round_no = round_no + 1

    if winner = battle_over?(new_units) do
      hp_left = Enum.map(new_units, fn unit -> unit.hp end) |> Enum.sum()
      %{winner: winner, hp_left: hp_left, rounds: round_no, score: round_no * hp_left}
    else
      do_part1({new_units, graph}, round_no)
    end
  end

  def do_round({units, graph}) do
    Enum.reduce(units, {units, 0}, fn _unit, {temp_units, index} ->
      {take_turn(temp_units, graph, index), index + 1}
    end)
    |> elem(0)
    |> Enum.filter(fn unit -> unit.alive end)
    |> sort_units
  end

  defp take_turn(units, graph, index) do
    unit = Enum.at(units, index)

    if unit.alive do
      unit = %{unit | position: new_position(unit, {units, graph})}

      units = List.replace_at(units, index, unit)
      enemy = enemy_adjacent(unit, units)

      if enemy do
        attack_enemy(enemy, units)
      else
        units
      end
    else
      units
    end
  end

  defp enemy_adjacent(%Unit{type: type, position: {row, col}}, units) do
    adjacent_coords = [{row - 1, col}, {row + 1, col}, {row, col - 1}, {row, col + 1}]

    adjacent =
      units
      |> Enum.filter(fn possible ->
        possible.type != type && possible.alive &&
          Enum.member?(adjacent_coords, possible.position)
      end)

    case adjacent do
      [] -> nil
      units -> Enum.min_by(units, fn unit -> unit.hp end)
    end
  end

  defp attack_enemy(target, units) do
    Enum.map(units, fn unit ->
      if unit == target do
        %{unit | hp: unit.hp - 3, alive: unit.hp > 3}
      else
        unit
      end
    end)
  end

  defp battle_over?(units) do
    grouped =
      units
      |> Enum.group_by(fn unit -> unit.type end)

    if map_size(grouped) == 1 do
      hd(units).type
    else
      false
    end
  end

  def new_position(unit, {units, graph}) do
    path =
      unit
      |> find_enemies(units)
      |> Enum.map(fn opp -> get_path(graph, units, unit, opp) || [] end)
      |> Enum.min_by(fn path -> length(path) end)

    case path do
      [_, next, _ | _] -> next
      _ -> unit.position
    end
  end

  defp find_enemies(unit, units) do
    Enum.filter(units, fn other -> other.alive && other.type != unit.type end)
  end

  defp get_path(graph, units, from, to) do
    other_units_at =
      units
      |> Enum.filter(fn unit -> unit.alive && unit != from && unit != to end)
      |> Enum.map(fn unit -> unit.position end)

    new_vertices = :digraph.vertices(graph) -- other_units_at

    graph
    |> :digraph_utils.subgraph(new_vertices)
    |> :digraph.get_short_path(from.position, to.position)
  end

  def parse_input(input) do
    {units, coords, _row} =
      input
      |> String.split("\n", trim: true)
      |> Enum.reduce({[], :digraph.new(), 1}, &parse_row/2)

    {sort_units(units), coords}
  end

  defp parse_row(row, {units, graph, row_num}) do
    {units, coords, _col_num} =
      row
      |> String.graphemes()
      |> Enum.reduce({units, graph, 1}, fn char, {units, graph, col_num} ->
        units = parse_unit(char, units, row_num, col_num)
        graph = parse_coord(char, graph, row_num, col_num)
        {units, graph, col_num + 1}
      end)

    {units, coords, row_num + 1}
  end

  defp sort_units(units) do
    Enum.sort_by(units, fn unit -> unit.position end)
  end

  defp parse_unit("#", units, _, _), do: units
  defp parse_unit(".", units, _, _), do: units

  defp parse_unit(unit, units, row, col) do
    [%Unit{type: @unit_types[unit], hp: 200, position: {row, col}, alive: true} | units]
  end

  defp parse_coord("#", graph, _, _), do: graph

  defp parse_coord(_, graph, row, col) do
    :digraph.add_vertex(graph, {row, col})

    [{row - 1, col}, {row, col - 1}]
    |> Enum.each(fn neighbour ->
      if :digraph.vertex(graph, neighbour) do
        :digraph.add_edge(graph, {row, col}, neighbour)
        :digraph.add_edge(graph, neighbour, {row, col})
      end
    end)

    graph
  end
end
