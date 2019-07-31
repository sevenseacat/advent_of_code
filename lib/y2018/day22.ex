defmodule Y2018.Day22 do
  use Advent.Day, no: 22

  @depth 3558
  @target {15, 740}

  @magic_x 16807
  @magic_y 48271
  @magic_erosion 20183

  @doc """
  iex> Day22.part1({10, 10}, 510)
  114
  """
  def part1({target_x, target_y} \\ @target, depth \\ @depth) do
    build_erosion_level_table({target_x, target_y}, {target_x, target_y}, depth)
    |> Enum.reduce(0, fn {_coord, level}, sum -> sum + level end)
  end

  @doc """
  iex> Day22.part2({10, 10}, 510)
  45
  """
  def part2({x, y} \\ @target, depth \\ @depth) do
    build_graph({x, y}, depth)
    |> Graph.dijkstra({0, 0, :torch}, {x, y, :torch})
    |> calculate_time(0)
  end

  def build_graph({x, y}, depth) do
    # Let's assume the shortest path doesn't go *way too far* out of the way,
    # and build an erosion table/graph thats twice as deep and twice as wide as
    # the target coordinate. If this doesn't find the shortest path, I'll expand
    # it.
    max_x = x * 2
    max_y = y * 2

    table = build_erosion_level_table({x, y}, {max_x, max_y}, depth)

    # Build a graph of all the possible moves from (0, 0) to (depth, depth) to
    # run a BFS search on it. This includes tool changes.
    graph = Graph.new() |> Graph.add_vertex({0, 0, :torch})

    Enum.reduce(0..max_x, graph, fn x, x_acc ->
      Enum.reduce(0..max_y, x_acc, fn y, acc ->
        current = {x, y, Map.get(table, {x, y})}

        [{x + 1, y, Map.get(table, {x + 1, y})}, {x, y + 1, Map.get(table, {x, y + 1})}]
        |> Enum.filter(fn {_, _, soil} -> soil != nil end)
        |> Enum.reduce(acc, fn move, graph -> add_move(graph, current, move) end)
        |> add_tool_changes(current)
      end)
    end)
  end

  def calculate_time(nil, 0), do: 0

  def calculate_time([{_, _, a}, {_, _, b} = second | rest], time) do
    case a == b do
      true -> calculate_time([second | rest], time + 1)
      false -> calculate_time([second | rest], time + 7)
    end
  end

  def calculate_time([_], time), do: time

  # Same soil type
  defp add_move(graph, {from_x, from_y, soil}, {to_x, to_y, soil}) do
    Enum.reduce(valid_tools(soil), graph, fn tool, graph ->
      graph
      |> Graph.add_edge({from_x, from_y, tool}, {to_x, to_y, tool}, weight: 1)
      |> Graph.add_edge({to_x, to_y, tool}, {from_x, from_y, tool}, weight: 1)
    end)
  end

  # Different soil type
  defp add_move(graph, {from_x, from_y, from_soil}, {to_x, to_y, to_soil}) do
    from_tools = valid_tools(from_soil)
    to_tools = valid_tools(to_soil)

    # https://kmrakibulislam.wordpress.com/2015/10/25/find-common-items-in-two-lists-in-elixir/
    case from_tools -- from_tools -- to_tools do
      nil ->
        graph

      [tool] ->
        graph
        |> Graph.add_edge({from_x, from_y, tool}, {to_x, to_y, tool}, weight: 1)
        |> Graph.add_edge({to_x, to_y, tool}, {from_x, from_y, tool}, weight: 1)
    end
  end

  defp add_tool_changes(graph, {x, y, soil}) do
    [t1, t2] = valid_tools(soil)

    graph
    |> Graph.add_edge({x, y, t1}, {x, y, t2}, weight: 7)
    |> Graph.add_edge({x, y, t2}, {x, y, t1}, weight: 7)
  end

  def build_erosion_level_table({target_x, target_y}, {max_x, max_y}, depth) do
    # This is just a summed-area table with a few extra conditions.
    Enum.reduce(0..max_x, %{}, fn x, x_acc ->
      Enum.reduce(0..max_y, x_acc, fn y, acc ->
        level =
          geo_level({x, y}, {target_x, target_y}, acc)
          |> to_erosion_level(depth)

        Map.put(acc, {x, y}, level)
      end)
    end)
    |> Enum.reduce(%{}, fn {coord, val}, acc ->
      Map.put(acc, coord, rem(val, 3))
    end)
  end

  def to_erosion_level(val, depth), do: rem(val + depth, @magic_erosion)

  defp geo_level({0, 0}, _target, _map), do: 0
  defp geo_level({x, y}, {x, y}, __map), do: 0
  defp geo_level({x, 0}, _target, _map), do: x * @magic_x
  defp geo_level({0, y}, _target, _map), do: y * @magic_y

  defp geo_level({x, y}, _target, map) do
    # Numbers are going to get way too big if we use them natively
    # Because we literally only care about the remainders of dividing a bunch of numbers,
    # we can divide by the lowest common multiple of all of the things - the remainders
    # will still be the same
    lcm = @magic_x * @magic_y * @magic_erosion
    rem(Map.get(map, {x - 1, y}) * Map.get(map, {x, y - 1}), lcm)
  end

  def display_grid(map, {max_x, max_y}) do
    Enum.each(0..max_y, fn y ->
      Enum.reduce(0..max_x, [], fn x, acc ->
        [get_symbol(rem(Map.get(map, {x, y}), 3)) | acc]
      end)
      |> Enum.reverse()
      |> List.to_string()
      |> IO.puts()
    end)

    map
  end

  defp valid_tools(0), do: [:climbing, :torch]
  defp valid_tools(1), do: [:climbing, :neither]
  defp valid_tools(2), do: [:torch, :neither]
  defp valid_tools(nil), do: []

  defp get_symbol(0), do: "."
  defp get_symbol(1), do: "="
  defp get_symbol(2), do: "|"

  def part1_verify, do: part1()
  def part2_verify, do: part2()
end
