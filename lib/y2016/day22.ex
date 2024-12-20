defmodule Y2016.Day22 do
  use Advent.Day, no: 22

  def part1(map) do
    map
    |> all_valid_moves()
    |> length()
  end

  # This is basically a giant slide puzzle. The grid of nodes starts with one
  # empty node, and the goal is to get the square in the top-right corner, to
  # the top-left corner.
  # This is probably overcomplicated because I originally tried to solve it
  # naively, first with a breadth-first search, then with a priority queue,
  # but the search space is just too large.
  # This solution keeps the priority queue, but makes one big assumption
  # about the data -
  #
  # Any states with both the empty node and the goal node in the same spots, are equivalent.
  #
  # We're not going to worry about the scenario where the data on two nodes
  # can be combined, that would create two empty nodes and double the search
  # space.
  def part2(map) do
    max_x = Enum.max_by(map, fn {{x, _}, _} -> x end) |> elem(0) |> elem(0)
    empty_coords = Enum.find(map, fn {_pos, node} -> node.used == 0 end) |> elem(0)

    get_shortest_result({map, empty_coords, {max_x, 0}})
  end

  defp get_shortest_result(state) do
    do_search(
      add_to_queue(PriorityQueue.new(), {legal_moves(state), 1}),
      MapSet.new()
    )
  end

  defp add_to_queue(queue, {states, turns}) do
    Enum.reduce(states, queue, fn {_map, _empty, target} = state, queue ->
      priority = turns + distance_to_goal(target) / 100
      PriorityQueue.push(queue, {state, turns}, priority)
    end)
  end

  defp distance_to_goal({x, y}), do: x + y

  defp do_search(queue, seen), do: do_move(PriorityQueue.pop(queue), seen)

  defp do_move({:empty, _queue}, _seen), do: raise("No winning states!")

  defp do_move(
         {{:value, {state, turns}}, queue},
         seen
       ) do
    if winning?(state) do
      # Winner winner chicken dinner.
      turns
    else
      hash = hash(state)

      if hash in seen do
        # Seen a better version of this state, scrap this one
        do_search(queue, seen)
      else
        # Calculate legal moves, record seen, etc.
        do_search(
          add_to_queue(queue, {legal_moves(state), turns + 1}),
          MapSet.put(seen, hash)
        )
      end
    end
  end

  defp legal_moves({state, empty_coords, target}) do
    {empty_coords, Map.get(state, empty_coords)}
    |> valid_connected_nodes(state)
    |> Enum.map(fn move -> make_move(state, move, target) end)
  end

  defp hash({_state, empty, target}), do: {empty, target}

  # The game is over if the node at x=0 y=0 has the target data.
  defp winning?({_map, _empty, target}), do: target == {0, 0}

  # Moving the emptiness from the empty node to another node. Kind of
  # the inverse of what we were doing before.
  defp make_move(state, [from: from_pos, to: to_pos], target) do
    from = Map.fetch!(state, from_pos)
    to = Map.fetch!(state, to_pos)

    new_state =
      state
      |> Map.update!(to_pos, fn to_node ->
        %{to_node | used: 0, available: to_node.size}
      end)
      |> Map.update!(from_pos, fn from_node ->
        %{
          from_node
          | used: to.used + from.used,
            available: from.available - to.used
        }
      end)

    new_target = if target == to_pos, do: from_pos, else: target

    {new_state, to_pos, new_target}
  end

  defp all_valid_moves(list) do
    Enum.flat_map(list, fn node -> valid_moves(node, list) end)
  end

  defp valid_moves({_pos, %{used: 0}}, _), do: []

  defp valid_moves({from_position, from}, map) do
    map
    |> Enum.filter(fn {_position, to} -> from != to && to.available >= from.used end)
    |> Enum.map(fn {to_position, _} -> [from: from_position, to: to_position] end)
  end

  # Connecting from the *empty* node to another node
  defp valid_connected_nodes({{x, y}, from}, map) do
    [{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}]
    |> Enum.flat_map(fn coord ->
      if Map.has_key?(map, coord), do: [{coord, Map.fetch!(map, coord)}], else: []
    end)
    |> Enum.filter(fn {_position, to} -> from.available >= to.used end)
    |> Enum.map(fn {to_position, _} -> [from: {x, y}, to: to_position] end)
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.drop(2)
    |> Enum.map(&parse_row/1)
    |> Map.new(fn node -> {{node.x, node.y}, node} end)
  end

  defp parse_row(row) do
    ~r/\/dev\/grid\/node-x(?<x>\d+)-y(?<y>\d+)(\s+)(?<size>\d+)T(\s+)(?<used>\d+)T(\s+)(?<available>\d+)T/
    |> Regex.named_captures(row)
    |> Enum.map(fn {key, val} -> {String.to_atom(key), String.to_integer(val)} end)
    |> Map.new()
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  def part2_verify, do: input() |> parse_input() |> part2()
end
