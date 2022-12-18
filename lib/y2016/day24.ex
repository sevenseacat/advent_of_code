defmodule Y2016.Day24 do
  use Advent.Day, no: 24
  alias Advent.PathGrid

  def part1(grid) do
    grid.units
    |> find_targets()
    |> Advent.full_permutations()
    |> Enum.map(&["0" | &1])
    |> min_distance(grid)
  end

  def part2(grid) do
    grid.units
    |> find_targets()
    |> Advent.full_permutations()
    |> Enum.map(&(["0" | &1] ++ ["0"]))
    |> min_distance(grid)
  end

  defp find_targets(units) when is_list(units) do
    Enum.map(units, & &1.identifier) -- ["0"]
  end

  defp min_distance(orders, %PathGrid{graph: graph, units: units}) do
    units = Map.new(units, &{&1.identifier, &1.position})

    orders
    |> Enum.reduce({[], %{}}, fn order, {data, cache} ->
      {distance, cache} = distance(graph, units, order, cache)
      {[{order, distance} | data], cache}
    end)
    |> elem(0)
    |> Enum.min_by(fn {_order, distance} -> distance end)
  end

  defp distance(graph, units, order, cache) do
    order
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.reduce({0, cache}, fn [from, to], {sum, cache} ->
      {length, cache} =
        case Map.get(cache, [from, to]) do
          nil ->
            length = length(Graph.dijkstra(graph, units[from], units[to])) - 1
            cache = Map.put(cache, [from, to], length)

            {length, cache}

          val ->
            {val, cache}
        end

      {sum + length, cache}
    end)
  end

  def parse_input(input), do: PathGrid.new(input)

  def part1_verify, do: input() |> parse_input() |> part1() |> elem(1)
  def part2_verify, do: input() |> parse_input() |> part2() |> elem(1)
end
