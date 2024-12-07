defmodule Y2019.Day20 do
  use Advent.Day, no: 20

  alias Advent.PathGrid

  # Grids manually manipulated to replace portal squares with units
  # For the real input:
  # G(GN) A(AV) J(JN) I(IP) O(OH) X(XN) B(OB) P(PR) V(VR) M(MK) W(WJ) L(XJ) K(KM)
  # U(UA) Q(QP) S(QM) E(QE) N(ND) T(IX) C(CZ) F(FQ) Y(YD) 2(UW) 5(RW) 6(PE) 1(UN)
  # 3(NC)
  def part1(%{graph: graph, start: start, destination: destination}) do
    Graph.get_shortest_path(graph, start, destination)
    |> length
    |> Kernel.-(1)
  end

  # @doc """
  # iex> Day20.part2("update or delete me")
  # "update or delete me"
  # """
  # def part2(input) do
  #   input
  # end

  def parse_input(input) do
    path_grid = PathGrid.new(input)
    # The parsed units aren't really *units* - they're starts, ends, and portals

    units = Enum.group_by(path_grid.units, & &1.identifier)

    {[start], units} = Map.pop(units, "@")
    {[destination], units} = Map.pop(units, "$")

    graph =
      Enum.reduce(units, path_grid.graph, fn {_id, [from, to]}, graph ->
        PathGrid.add_special_path(graph, {from.position, to.position})
      end)

    %{graph: graph, start: start.position, destination: destination.position}
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  # def part2_verify, do: input() |> parse_input() |> part2()
end
