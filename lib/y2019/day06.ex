defmodule Y2019.Day06 do
  use Advent.Day, no: 6

  def part1(input) do
    input
    |> parse_input
    |> build_tree(:directed)
    |> count_orbits
  end

  def part2(input) do
    input
    |> parse_input()
    |> build_tree(:undirected)
    |> length_of_path_between("YOU", "SAN")
  end

  defp build_tree(orbits, type) do
    graph = :digraph.new()

    Enum.reduce(orbits, graph, fn [object, orbiter], g ->
      :digraph.add_vertex(g, object)
      :digraph.add_vertex(g, orbiter)
      :digraph.add_edge(g, object, orbiter)

      if(type == :undirected) do
        :digraph.add_edge(g, orbiter, object)
      end

      g
    end)
  end

  defp length_of_path_between(graph, from, to) do
    # number of transfers is number of hops between vertices, not including from and to
    # path is just number of vertices
    Enum.count(:digraph.get_short_path(graph, from, to)) - 3
  end

  defp count_orbits(graph) do
    Enum.reduce(:digraph.vertices(graph), 0, fn vertex, count ->
      count + Enum.count(:digraph_utils.reachable_neighbours([vertex], graph))
    end)
  end

  defp parse_input(data) do
    data
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn orbit -> String.split(orbit, ")") end)
  end

  def part1_verify, do: input() |> part1()
  def part2_verify, do: input() |> part2()
end
