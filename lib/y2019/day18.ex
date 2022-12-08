defmodule Y2019.Day18 do
  use Advent.Day, no: 18
  alias Advent.Grid

  def part1(state) do
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
      cache_value = {state.unlocked, state.position}

      if MapSet.member?(seen, cache_value) do
        # Seen a shorter version of this state already.
        do_search(queue, seen)
      else
        do_search(add_to_queue(queue, reachable_keys(state)), MapSet.put(seen, cache_value))
      end
    end
  end

  defp search_done?(state), do: Enum.empty?(state.keys)

  defp reachable_keys(state) do
    passable_nodes = Graph.vertices(state.graph) -- Map.values(state.locks)
    subgraph = Graph.subgraph(state.graph, passable_nodes)

    state.keys
    |> Enum.map(fn {key, position} ->
      {key, Graph.Pathfinding.dijkstra(subgraph, position, state.position)}
    end)
    |> Enum.reject(fn {_key, path} -> path == nil end)
    |> Enum.map(fn {key, path} -> {key, path, length(path) - 1} end)
    |> Enum.sort_by(fn {_key, _path, distance} -> distance end)
    # Let's assume we're not going to be skipping to far-away nodes on a shortest path
    |> Enum.take(5)
    |> Enum.map(fn {key, path, distance} -> pick_up_key(state, {key, hd(path), distance}) end)
  end

  defp pick_up_key(state, {key, position, length}) do
    state
    |> Map.merge(%{
      locks: Map.delete(state.locks, String.upcase(key)),
      keys: Map.delete(state.keys, key),
      unlocked: MapSet.put(state.unlocked, key),
      distance: state.distance + length,
      position: position
    })
  end

  # @doc """
  # iex> Day18.part1("update or delete me")
  # "update or delete me"
  # """
  # def part2(input) do
  #   input
  # end

  def parse_input(input) do
    %Grid{graph: graph, units: units} = Grid.new(input)
    units = Enum.map(units, &{&1.identifier, &1.position})
    start = Enum.find(units, fn {u, _} -> u == "@" end)
    keys = Enum.filter(units, fn {u, _} -> u != "@" && String.downcase(u) == u end) |> Map.new()
    locks = Enum.filter(units, fn {u, _} -> u != "@" && String.upcase(u) == u end) |> Map.new()

    %{
      graph: graph,
      keys: keys,
      locks: locks,
      position: elem(start, 1),
      unlocked: MapSet.new(),
      distance: 0
    }
  end

  def part1_verify, do: input() |> parse_input() |> part1()

  # def part2_verify, do: input() |> parse_input() |> part2()
end
