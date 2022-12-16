defmodule Y2022.Day16 do
  use Advent.Day, no: 16

  @start "AA"
  @max_time 30

  def part1(input, max_time \\ @max_time), do: do_parts(input, max_time, 1)
  def part2(input), do: do_parts(input, 26, 2)

  defp do_parts(input, max_time, players) do
    graph = build_graph(input)

    openable_valves = Enum.filter(input, fn %{flow: flow} -> flow > 0 end)

    paths =
      [@start | Enum.map(openable_valves, & &1.id)]
      |> Advent.permutations(2)
      |> Enum.reduce(%{}, fn [from, to], acc ->
        Map.put(acc, [from, to], tl(Graph.dijkstra(graph, from, to)))
      end)

    get_maximum_pressure_release(openable_valves, paths, max_time, players)
    |> Map.get(:released_amount)
  end

  def get_maximum_pressure_release(openable_valves, paths, max_time, players) do
    initial_state = %{
      at: List.duplicate(@start, players),
      openable: openable_valves,
      open: [],
      closed_valve_count: length(openable_valves),
      time: 0,
      released_amount: 0,
      release_rate: 0,
      moves: List.duplicate([], players),
      next: List.duplicate([], players),
      targets: List.duplicate(nil, players),
      players: players,
      max_time: max_time
    }

    do_search([next_move(initial_state, paths)], [], paths, %{released_amount: 0})
  end

  defp do_search([], [], _paths, best), do: best

  defp do_search([], next_level_states, paths, best) do
    # level = next_level_states |> hd |> hd |> Map.fetch!(:time)
    # IO.puts("* Level #{level}: #{length(next_level_states)} states to check.")
    do_search(next_level_states, [], paths, best)
  end

  defp do_search([[] | rest], next_level_states, paths, best) do
    do_search(rest, next_level_states, paths, best)
  end

  defp do_search([[state | rest1] | rest2], next_level_states, paths, best) do
    state =
      if state.closed_valve_count > 0 || state.time >= state.max_time do
        state
      else
        # Fast forward to @max_time, we've done all we can
        extra_release = (state.max_time - state.time) * state.release_rate
        %{state | time: state.max_time, released_amount: state.released_amount + extra_release}
      end

    if state.time >= state.max_time do
      best = if state.released_amount >= best.released_amount, do: state, else: best
      do_search([rest1 | rest2], next_level_states, paths, best)
    else
      # There's still more time, keep moving!
      moves = next_move(state, paths)

      if Enum.empty?(moves) do
        do_search([rest1 | rest2], next_level_states, paths, best)
      else
        do_search([rest1 | rest2], [moves | next_level_states], paths, best)
      end
    end
  end

  defp build_graph(input) do
    Enum.reduce(input, Graph.new(), fn %{id: id, tunnels: tunnels}, graph ->
      graph = Graph.add_vertex(graph, id)

      Enum.reduce(tunnels, graph, fn tunnel, graph ->
        graph
        |> Graph.add_vertex(tunnel)
        |> Graph.add_edge(id, tunnel)
      end)
    end)
  end

  defp next_move(state, paths) do
    # This always ticks with each move
    state = %{
      state
      | released_amount: state.released_amount + state.release_rate,
        time: state.time + 1
    }

    state
    |> maybe_make_move(paths, 1)
    |> Enum.map(&maybe_make_move(&1, paths, 2))
    |> List.flatten()
  end

  defp maybe_make_move(%{players: players} = state, paths, turn) when turn <= players do
    turn = turn - 1

    case {Enum.at(state.next, turn), Enum.at(state.targets, turn)} do
      # Nothing to do, find a new move
      {[], nil} ->
        # For a second player, the next move depends on every possible move of the first
        if Enum.empty?(state.openable) do
          # If there's nothing openable, there's always the option to do nothing
          [state]
        else
          Enum.map(state.openable, fn valve ->
            [at | next] = Map.get(paths, [Enum.at(state.at, turn), valve.id])

            %{
              state
              | at: List.replace_at(state.at, turn, at),
                next: List.replace_at(state.next, turn, next),
                targets: List.replace_at(state.targets, turn, valve),
                moves: List.update_at(state.moves, turn, &[{at, state.time} | &1]),
                openable: List.delete(state.openable, valve)
            }
          end)
        end

      # At a closed valve, open it
      {[], valve} ->
        [
          %{
            state
            | open: [valve | state.open],
              targets: List.replace_at(state.targets, turn, nil),
              release_rate: state.release_rate + valve.flow,
              closed_valve_count: state.closed_valve_count - 1,
              moves: List.update_at(state.moves, turn, &[{:open, state.time} | &1])
          }
        ]

      # Keep walking towards the next valve
      {[move | rest], _target} ->
        [
          %{
            state
            | at: List.replace_at(state.at, turn, move),
              next: List.replace_at(state.next, turn, rest),
              moves: List.update_at(state.moves, turn, &[{move, state.time} | &1])
          }
        ]
    end
  end

  # If trying to take turn 2 in a 1-player event
  defp maybe_make_move(state, _paths, _turn), do: state

  @doc """
  iex> Day16.parse_input("Valve GG has flow rate=0; tunnels lead to valves FF, HH\\nValve HH has flow rate=22; tunnel leads to valve GG\\n")
  [%{id: "GG", flow: 0, tunnels: ["FF", "HH"]}, %{id: "HH", flow: 22, tunnels: ["GG"]}]
  """
  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_row/1)
  end

  defp parse_row(row) do
    [id, flow | tunnels] = Regex.scan(~r/[A-Z]{2}|\d+/, row)
    %{id: hd(id), flow: String.to_integer(hd(flow)), tunnels: List.flatten(tunnels)}
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  # def part2_verify, do: input() |> parse_input() |> part2()
end
