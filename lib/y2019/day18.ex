defmodule Y2019.Day18 do
  use Advent.Day, no: 18
  alias Advent.Grid

  def parts(state) do
    state
    |> find_shortest_path()
    |> Map.get(:distance)
  end

  defp find_shortest_path(state) do
    PriorityQueue.new()
    |> add_to_queue(reachable_keys(state))
    |> do_search(MapSet.new())
  end

  defp add_to_queue(queue, states) do
    Enum.reduce(states, queue, fn state, queue ->
      PriorityQueue.push(queue, state, state.distance)
    end)
  end

  defp do_search(queue, seen) do
    do_search_element(PriorityQueue.pop(queue), seen)
  end

  defp do_search_element({:empty, _queue}, _seen), do: raise("No winning states!")

  defp do_search_element({{:value, state}, queue}, seen) do
    if search_done?(state) do
      # Winner winner chicken dinner.
      state
    else
      # Calculate legal moves, record seen, etc.
      cache_value = {state.unlocked, state.robots}

      if MapSet.member?(seen, cache_value) do
        # Seen a shorter version of this state already.
        do_search(queue, seen)
      else
        do_search(add_to_queue(queue, reachable_keys(state)), MapSet.put(seen, cache_value))
      end
    end
  end

  defp search_done?(state), do: state.keys == %{}

  defp reachable_keys(state) do
    passable_nodes = Graph.vertices(state.graph) -- Map.values(state.locks)
    subgraph = Graph.subgraph(state.graph, passable_nodes)

    state.robots
    |> Enum.flat_map(fn {robot_id, robot_position} ->
      reachable_keys(state.keys, subgraph, robot_position)
      |> Enum.map(fn {key, path, distance} ->
        pick_up_key(state, robot_id, {key, hd(path), distance})
      end)
    end)
  end

  defp reachable_keys(keys, graph, robot_position) do
    keys
    |> Enum.map(fn {key, key_position} ->
      {key, Graph.Pathfinding.dijkstra(graph, key_position, robot_position)}
    end)
    |> Enum.reject(fn {_key, path} -> path == nil end)
    |> Enum.map(fn {key, path} -> {key, path, length(path) - 1} end)
    |> Enum.sort_by(fn {_key, _path, distance} -> distance end)
    # Let's assume we're not going to be skipping to far-away nodes on a shortest path
    |> Enum.take(5)
  end

  defp pick_up_key(state, robot_id, {key, position, length}) do
    state
    |> Map.merge(%{
      locks: Map.delete(state.locks, String.upcase(key)),
      keys: Map.delete(state.keys, key),
      unlocked: MapSet.put(state.unlocked, key),
      distance: state.distance + length,
      robots: Map.put(state.robots, robot_id, position)
    })
  end

  def parse_input(input) do
    %Grid{graph: graph, units: units} = Grid.new(input)
    units = Enum.map(units, &{&1.identifier, &1.position})

    robots =
      Enum.filter(units, fn {u, _} -> u == "@" end)
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {robot, index}, acc -> Map.put(acc, index, elem(robot, 1)) end)

    keys = Enum.filter(units, fn {u, _} -> u != "@" && String.downcase(u) == u end) |> Map.new()
    locks = Enum.filter(units, fn {u, _} -> u != "@" && String.upcase(u) == u end) |> Map.new()

    %{
      graph: graph,
      keys: keys,
      locks: locks,
      robots: robots,
      unlocked: MapSet.new(),
      distance: 0
    }
  end

  def part1_verify, do: input() |> parse_input() |> parts()
  # def part2_verify, do: input("day18-part2") |> parse_input() |> parts()
end
