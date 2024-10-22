defmodule Y2021.Day23 do
  use Advent.Day, no: 23

  def parts(positions) do
    get_optimal_result({positions, 0})
  end

  @doc """
  Runs a priority search, returning once a result has been found. As we process nodes in order
  of energy use ascending, the first result will automatically be the lowest energy use solution.
  """
  def get_optimal_result(state) do
    do_search(
      add_to_queue(PriorityQueue.new(), legal_moves(state)),
      MapSet.new()
    )
  end

  defp add_to_queue(queue, states) do
    Enum.reduce(states, queue, fn {_coord, energy} = state, queue ->
      PriorityQueue.push(queue, state, energy)
    end)
  end

  defp do_search(queue, seen) do
    do_search_element(PriorityQueue.pop(queue), seen)
  end

  defp do_search_element({:empty, _queue}, _seen), do: raise("No winning states!")

  defp do_search_element(
         {{:value, {positions, energy_used} = state}, queue},
         seen
       ) do
    if all_in_correct_places?(positions) do
      # Winner winner chicken dinner.
      energy_used
    else
      if positions in seen do
        # Seen a better version of this state, scrap this one
        do_search(queue, seen)
      else
        # Calculate legal moves, record seen, etc.
        do_search(
          add_to_queue(queue, legal_moves(state)),
          MapSet.put(seen, positions)
        )
      end
    end
  end

  def legal_moves({positions, _energy} = state) do
    positions
    |> select_movable_amphipods()
    |> Enum.flat_map(fn amphipod -> possible_moves(state, amphipod) end)
  end

  defp select_movable_amphipods(positions) do
    positions
    |> Enum.filter(fn {_coord, type} -> type != nil end)
    |> Enum.filter(fn {coord, _type} = position ->
      case coord do
        # An amphipod is in the hallway and can only move home if there are
        # no other-type amphipods in its home.
        {_x, 0} ->
          can_go_home?(position, positions)

        # If this is at home, it is movable if its blocking something
        # If not already at home or blocking an other-type amphipod, may go out
        # into the hallway as long as there's somewhere for it to go left or right
        {x, y} ->
          home? = if at_home?(position), do: blocking_other?(positions, position), else: true

          home? && nothing_blocking?(positions, {x, y}) &&
            (Map.get(positions, {x - 1, 0}) == nil || Map.get(positions, {x + 1, 0}) == nil)
      end
    end)
  end

  # Can only go home, either to first or second spot
  defp possible_moves(state, {{_x, 0}, _type} = position) do
    home_moves(state, position)
  end

  # Can go out into the hallway, but not to block a room and not past any other animal
  # May also be able to go home
  defp possible_moves({positions, energy} = state, {{x, y}, type} = position) do
    home_moves =
      if can_go_home?(position, positions) do
        home_moves(state, position)
      else
        []
      end

    hallway_moves =
      (Enum.take_while(x..0, fn x -> Map.get(positions, {x, 0}) == nil end) ++
         Enum.take_while(x..10, fn x -> Map.get(positions, {x, 0}) == nil end))
      |> Enum.filter(fn x -> !Enum.member?([2, 4, 6, 8], x) end)
      |> Enum.map(fn new_x ->
        distance = abs(new_x - x) + y
        energy_use = distance * energy_use(type)

        new_positions = make_move(positions, {x, y}, {new_x, 0}, type)
        {new_positions, energy + energy_use}
      end)

    home_moves ++ hallway_moves
  end

  defp home_moves({positions, energy}, {{x, y}, type}) do
    new_path = path_home({x, y}, type, positions)
    energy_use = length(new_path) * energy_use(type)

    new_positions = make_move(positions, {x, y}, hd(new_path), type)
    [{new_positions, energy + energy_use}]
  end

  defp make_move(positions, from, to, type) do
    positions
    |> Map.delete(from)
    |> Map.put_new(to, type)
  end

  defp blocking_other?(positions, {{x, y}, type}) do
    Enum.any?((y + 1)..4, fn num ->
      Map.get(positions, {x, num}, type) != type
    end)
  end

  defp nothing_blocking?(_positions, {_x, 1}), do: true

  defp nothing_blocking?(positions, {x, y}) do
    Enum.all?(1..(y - 1), fn new_y -> Map.get(positions, {x, new_y}) == nil end)
  end

  defp can_go_home?({coord, type}, positions) do
    path_clear =
      path_home(coord, type, positions)
      |> Enum.all?(fn new_coord -> Map.get(positions, new_coord) == nil end)

    no_other_types_home =
      Enum.all?(2..4, fn num ->
        Enum.member?([type, nil], Map.get(positions, {home_column(type), num}))
      end)

    path_clear && no_other_types_home
  end

  defp path_home(coord, type, positions) do
    home_column = home_column(type)

    []
    |> go_to_hallway(coord)
    |> go_to_home_column(coord, home_column)
    |> go_to_home(positions, type)
  end

  defp go_to_hallway(path, {_x, y}) when y == 0 or y == 1, do: path

  defp go_to_hallway(path, {x, y}) do
    Enum.reduce((y - 1)..1, path, fn new_y, acc -> [{x, new_y} | acc] end)
  end

  defp go_to_home_column(path, {x, 0}, home_column) do
    if home_column > x do
      go_to_home_column(path, {x + 1, 1}, home_column)
    else
      go_to_home_column(path, {x - 1, 1}, home_column)
    end
  end

  defp go_to_home_column(path, {x, _y}, home_column) do
    Enum.reduce(x..home_column, path, fn new_x, acc -> [{new_x, 0} | acc] end)
  end

  # The deepest home value that doesn't have something in it - works for
  # both parts 1 and 2.
  defp go_to_home(path, positions, type) do
    x = home_column(type)
    {{_x, y}, _type} = Enum.max_by(positions, fn {{_x, y}, _type} -> y end)

    1..y
    |> Enum.take_while(fn y -> !Map.has_key?(positions, {x, y}) end)
    |> Enum.reduce(path, fn new_y, acc -> [{x, new_y} | acc] end)
  end

  defp home_column(:amber), do: 2
  defp home_column(:bronze), do: 4
  defp home_column(:copper), do: 6
  defp home_column(:desert), do: 8

  defp energy_use(:amber), do: 1
  defp energy_use(:bronze), do: 10
  defp energy_use(:copper), do: 100
  defp energy_use(:desert), do: 1000

  defp at_home?({{col, _y}, type}), do: home_column(type) == col

  defp all_in_correct_places?(positions) do
    Enum.all?(positions, fn {{x, _y}, type} -> x == home_column(type) end)
  end

  def part1_input(:real) do
    %{
      {2, 1} => :desert,
      {2, 2} => :copper,
      {4, 1} => :bronze,
      {4, 2} => :amber,
      {6, 1} => :copper,
      {6, 2} => :desert,
      {8, 1} => :amber,
      {8, 2} => :bronze
    }
  end

  def part1_input(:sample) do
    %{
      {2, 1} => :bronze,
      {2, 2} => :amber,
      {4, 1} => :copper,
      {4, 2} => :desert,
      {6, 1} => :bronze,
      {6, 2} => :copper,
      {8, 1} => :desert,
      {8, 2} => :amber
    }
  end

  def part2_input(:real) do
    %{
      {2, 1} => :desert,
      {2, 2} => :desert,
      {2, 3} => :desert,
      {2, 4} => :copper,
      {4, 1} => :bronze,
      {4, 2} => :copper,
      {4, 3} => :bronze,
      {4, 4} => :amber,
      {6, 1} => :copper,
      {6, 2} => :bronze,
      {6, 3} => :amber,
      {6, 4} => :desert,
      {8, 1} => :amber,
      {8, 2} => :amber,
      {8, 3} => :copper,
      {8, 4} => :bronze
    }
  end

  def part2_input(:sample) do
    %{
      {2, 1} => :bronze,
      {2, 2} => :desert,
      {2, 3} => :desert,
      {2, 4} => :amber,
      {4, 1} => :copper,
      {4, 2} => :copper,
      {4, 3} => :bronze,
      {4, 4} => :desert,
      {6, 1} => :bronze,
      {6, 2} => :bronze,
      {6, 3} => :amber,
      {6, 4} => :copper,
      {8, 1} => :desert,
      {8, 2} => :amber,
      {8, 3} => :copper,
      {8, 4} => :amber
    }
  end

  def part1_verify, do: part1_input(:real) |> parts()
  def part2_verify, do: part2_input(:real) |> parts()
end
