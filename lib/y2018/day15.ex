defmodule Y2018.Day15 do
  use Advent.Day, no: 15

  alias Y2018.Day15.Unit
  alias Advent.PathGrid

  def part1(input) do
    {units, graph} = parse_input(input)

    do_part1({units, graph}, count_elves(units), 0, &no_dead_elf_checker/2)
  end

  def part2(input) do
    {units, graph} = parse_input(input)
    do_part2({units, graph}, count_elves(units), 4)
  end

  defp do_part1({units, graph}, elf_count, round_no, dead_elf_checker) do
    {new_units, round_no} =
      try do
        {do_round({units, graph}), round_no + 1}
      catch
        new_units ->
          {new_units |> Enum.filter(fn unit -> unit.alive end), round_no}
      end

    cond do
      winner = battle_over?(new_units) ->
        hp_left = Enum.map(new_units, fn unit -> unit.hp end) |> Enum.sum()

        %{
          winner: winner,
          hp_left: hp_left,
          rounds: round_no,
          score: round_no * hp_left
        }

      dead_elf_checker.(elf_count, new_units) ->
        %{winner: "G"}

      true ->
        do_part1({new_units, graph}, elf_count, round_no, dead_elf_checker)
    end
  end

  defp do_part2({units, graph}, elf_count, elf_power) do
    result = do_part1({units, graph}, elf_count, 0, &dead_elf_checker/2)

    if result.winner == "E" do
      Map.put(result, :power, elf_power)
    else
      elf_power = elf_power + 1
      units = update_elf_power(units, elf_power)
      do_part2({units, graph}, elf_count, elf_power)
    end
  end

  defp update_elf_power(units, power) do
    Enum.map(units, fn
      %{type: "E"} = elf -> %{elf | power: power}
      goblin -> goblin
    end)
  end

  defp count_elves(units) do
    Enum.count(units, fn unit -> unit.type == "E" end)
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
        attack_enemy(unit, enemy, units)
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
      [] ->
        nil

      units ->
        {_hp, weakest_units} =
          units
          |> Enum.group_by(fn unit -> unit.hp end)
          |> Enum.sort_by(fn {hp, _} -> hp end)
          |> hd()

        Enum.min_by(weakest_units, fn unit -> unit.position end)
    end
  end

  defp attack_enemy(attacker, target, units) do
    Enum.map(units, fn unit ->
      if unit == target do
        %{unit | hp: unit.hp - attacker.power, alive: unit.hp > attacker.power}
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
    if find_enemies(unit, units) == [], do: throw(units)

    if enemy_adjacent(unit, units) do
      # Don't move, stay and attack.
      unit.position
    else
      # I like to move it move it
      calculate_new_position(unit, {units, graph})
    end
  end

  defp calculate_new_position(unit, {units, graph}) do
    paths =
      unit
      |> find_enemies(units)
      |> Enum.map(fn enemy -> best_path_between(unit.position, enemy.position, {units, graph}) end)
      |> Enum.filter(fn path -> path != nil end)

    if Enum.empty?(paths) do
      unit.position
    else
      paths
      |> Enum.min_by(fn [_from, next | _rest] = path -> {length(path), next} end)
      |> Enum.at(1)
    end
  end

  def best_path_between({from_row, from_col} = from, to, {units, graph}) do
    other_unit_coords =
      units
      |> Enum.filter(fn unit -> unit.alive end)
      |> Enum.map(fn unit -> unit.position end)
      |> Enum.reject(fn coord -> coord == from || coord == to end)

    open_coords = PathGrid.floor_spaces(graph) -- other_unit_coords

    weights = %{
      {from_row - 1, from_col} => 0,
      {from_row, from_col - 1} => 1,
      {from_row, from_col + 1} => 2,
      {from_row + 1, from_col} => 3
    }

    graph
    |> Graph.subgraph(open_coords)
    |> Graph.a_star(from, to, fn {row, col} ->
      # Prefer the coordinates in reading order, for the first step.
      Map.get(weights, {row, col}, 0)
    end)
  end

  defp find_enemies(unit, units) do
    Enum.filter(units, fn other -> other.alive && other.type != unit.type end)
  end

  def parse_input(input, power \\ %{"G" => 3, "E" => 3}) do
    %PathGrid{graph: graph, units: units} = PathGrid.new(input)

    units =
      units
      |> Enum.map(fn unit -> convert_unit(unit, power) end)
      |> sort_units()

    {units, graph}
  end

  defp sort_units(units) do
    Enum.sort_by(units, fn unit -> unit.position end)
  end

  defp convert_unit(%{identifier: identifier, position: position}, power_levels) do
    %Unit{
      type: identifier,
      hp: 200,
      position: position,
      alive: true,
      power: power_levels[identifier]
    }
  end

  def display_grid({units, graph}) do
    for row <- 1..35, col <- 1..35 do
      if unit = Enum.find(units, fn unit -> unit.position == {row, col} end) do
        unit.type
      else
        if PathGrid.floor?(graph, {row, col}), do: ".", else: "#"
      end
    end
    |> Enum.chunk_every(35)
    |> Enum.map(&List.to_string/1)
    |> Enum.map(&IO.puts/1)
  end

  # Only relevant for part 2 - escape hatch to stop running the game when an elf dies
  defp no_dead_elf_checker(_elf_count, _units), do: false
  defp dead_elf_checker(elf_count, units), do: elf_count != count_elves(units)

  def part1_verify, do: input() |> part1() |> Map.get(:score)
  def part2_verify, do: input() |> part2() |> Map.get(:score)
end
