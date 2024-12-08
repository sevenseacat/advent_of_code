defmodule Y2019.Day20 do
  use Advent.Day, no: 20

  defmodule SearchState do
    defstruct [:position, :level, :distance]
  end

  alias Advent.PathGrid

  # Grids manually manipulated to replace portal squares with units
  # For the real input:
  # G(GN) A(AV) J(JN) I(IP) O(OH) X(XN) B(OB) P(PR) V(VR) M(MK) W(WJ) L(XJ) K(KM)
  # U(UA) Q(QP) S(QM) E(QE) N(ND) T(IX) C(CZ) F(FQ) Y(YD) 2(UW) 5(RW) 6(PE) 1(UN)
  # 3(NC)
  def part1(%{graph: graph, start: start, destination: destination, units: units}) do
    # The parsed units aren't really *units* - they're starts, ends, and portals
    grouped = Enum.group_by(units, & &1.identifier)

    graph =
      Enum.reduce(grouped, graph, fn
        {_id, [from, to]}, graph -> PathGrid.add_special_path(graph, {from.position, to.position})
        {_id, [_one]}, graph -> graph
      end)

    Graph.get_shortest_path(graph, start, destination)
    |> length
    |> Kernel.-(1)
  end

  def part2(%{graph: graph, start: start, destination: destination, units: units}) do
    {max_row, max_col} = PathGrid.size(graph)

    # But we do need a special list of the units - some are only available on some levels
    targets =
      Enum.map(units, fn %{identifier: identifier, position: {row, col}} ->
        {available, level_change} =
          cond do
            identifier == "@" -> {[], nil}
            identifier == "$" -> {[0], 0}
            row == 1 || row == max_row || col == 1 || col == max_col -> {[1], -1}
            true -> {[0, 1], 1}
          end

        %{
          identifier: identifier,
          position: {row, col},
          available: available,
          level_change: level_change
        }
      end)

    run_priority_queue_search(
      graph,
      targets,
      destination,
      add_to_queue(
        PriorityQueue.new(),
        legal_moves(graph, targets, %SearchState{
          position: start,
          level: 0,
          distance: 0
        })
      ),
      MapSet.new([{start, 0}])
    )
  end

  defp add_to_queue(queue, states) do
    Enum.reduce(states, queue, fn state, queue ->
      PriorityQueue.push(queue, state, state.distance)
    end)
  end

  def legal_moves(graph, targets, state) do
    available = if state.level == 0, do: 0, else: 1

    targets
    |> Enum.filter(fn t -> available in t.available end)
    |> Enum.map(fn t ->
      {t, Graph.get_shortest_path(graph, state.position, t.position)}
    end)
    |> Enum.filter(fn {_, path} -> path != nil end)
    |> Enum.map(fn {unit, path} ->
      # If this is a portal, go to the other side of the portal
      portal =
        Enum.find(targets, fn t ->
          t.identifier == unit.identifier && t.position != unit.position
        end)

      %SearchState{
        position: if(portal, do: portal.position, else: unit.position),
        distance: state.distance + length(path),
        level: state.level + unit.level_change
      }
    end)
  end

  defp run_priority_queue_search(graph, targets, destination, queue, seen),
    do: do_move(PriorityQueue.pop(queue), graph, targets, destination, seen)

  defp do_move({:empty, _queue}, _graph, _targets, _destination, _seen) do
    raise "No winning states!"
  end

  defp do_move(
         {{:value, state}, queue},
         graph,
         targets,
         destination,
         seen
       ) do
    if state.position == destination do
      # Winner winner chicken dinner.
      state.distance - 1
    else
      hash = {state.position, state.level}

      if MapSet.member?(seen, hash) do
        # Seen a better version of this state, scrap this one
        run_priority_queue_search(graph, targets, destination, queue, seen)
      else
        # Calculate legal moves, record seen, etc.
        run_priority_queue_search(
          graph,
          targets,
          destination,
          add_to_queue(
            queue,
            legal_moves(
              graph,
              targets,
              state
            )
          ),
          MapSet.put(seen, hash)
        )
      end
    end
  end

  def parse_input(input) do
    path_grid = PathGrid.new(input)

    start = Enum.find(path_grid.units, &(&1.identifier == "@"))
    destination = Enum.find(path_grid.units, &(&1.identifier == "$"))

    %{
      graph: path_grid.graph,
      start: start.position,
      destination: destination.position,
      units: path_grid.units
    }
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  def part2_verify, do: input() |> parse_input() |> part2()
end
