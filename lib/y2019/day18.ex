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

  defp search_done?(%{key_count: 0}), do: true
  defp search_done?(_), do: false

  defp reachable_keys(state) do
    state.robots
    |> Enum.flat_map(fn {robot_id, robot_position} ->
      state.keys
      |> Map.get(robot_id)
      |> reachable_keys(state.graph, robot_position)
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
    |> Enum.take(4)
  end

  defp pick_up_key(state, robot_id, {key, position, length}) do
    new_keys = Map.update!(state.keys, robot_id, fn robot_keys -> Map.delete(robot_keys, key) end)

    graph =
      case Map.get(state.locks, String.upcase(key)) do
        # No actual lock for this key
        nil ->
          state.graph

        # Lock has been removed - add the lock node back to the graph
        {row, col} ->
          graph = Graph.add_vertex(state.graph, {row, col})

          [{row - 1, col}, {row + 1, col}, {row, col - 1}, {row, col + 1}]
          |> Enum.reduce(graph, fn coord, graph ->
            if Graph.has_vertex?(graph, coord) do
              graph
              |> Graph.add_edge({row, col}, coord)
              |> Graph.add_edge(coord, {row, col})
            else
              graph
            end
          end)
      end

    state
    |> Map.merge(%{
      graph: graph,
      locks: Map.delete(state.locks, String.upcase(key)),
      keys: new_keys,
      unlocked: MapSet.put(state.unlocked, key),
      distance: state.distance + length,
      robots: Map.put(state.robots, robot_id, position),
      key_count: state.key_count - 1
    })
  end

  def parse_input(input) do
    %Grid{graph: graph, units: units} = Grid.new(input)
    units = Enum.map(units, &{&1.identifier, &1.position})

    robots =
      Enum.filter(units, fn {u, _} -> u == "@" end)
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {robot, index}, acc -> Map.put(acc, index, elem(robot, 1)) end)

    keys = Enum.filter(units, fn {u, _} -> u != "@" && String.downcase(u) == u end)
    key_count = length(keys)
    locks = Enum.filter(units, fn {u, _} -> u != "@" && String.upcase(u) == u end) |> Map.new()

    # Split out the keys into only those that each robot will be able to reach
    keys =
      if map_size(robots) == 1 do
        id = Map.keys(robots) |> List.first()
        %{id => keys}
      else
        Enum.group_by(keys, fn {_key_id, key_position} ->
          robots
          |> Enum.find(robots, fn {_robot_id, robot_position} ->
            Graph.Pathfinding.dijkstra(graph, key_position, robot_position)
          end)
          |> elem(0)
        end)
      end
      |> Enum.map(fn {robot_id, keys} -> {robot_id, Map.new(keys)} end)
      |> Enum.into(%{})

    # Delete the lock nodes from the graph. We'll put them back in when they are unlocked.
    graph =
      Enum.reduce(locks, graph, fn {_, coord}, graph ->
        Graph.delete_vertex(graph, coord)
      end)

    %{
      graph: graph,
      keys: keys,
      locks: locks,
      robots: robots,
      unlocked: MapSet.new(),
      distance: 0,
      key_count: key_count
    }
  end

  def part1_verify, do: input() |> parse_input() |> parts()
  def part2_verify, do: input("day18-part2") |> parse_input() |> parts()
end
