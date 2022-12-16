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
      at: @start,
      openable: openable_valves,
      open: [],
      time: 0,
      released_amount: 0,
      release_rate: 0,
      moves: [],
      next: List.duplicate([], players),
      targets: List.duplicate(nil, players),
      max_time: max_time
    }

    do_search([next_move(initial_state, paths)], [], paths, %{released_amount: 0})
  end

  defp do_search([], [], _paths, best), do: best

  defp do_search([], next_level_states, paths, best) do
    # level = next_level_states |> hd |> hd |> Map.fetch!(:open) |> length
    # IO.puts("* Level #{level}: #{length(next_level_states)} states to check.")
    do_search(next_level_states, [], paths, best)
  end

  defp do_search([[] | rest], next_level_states, paths, best) do
    do_search(rest, next_level_states, paths, best)
  end

  defp do_search([[state | rest1] | rest2], next_level_states, paths, best) do
    state =
      if Enum.any?(state.openable) || state.time >= 30 do
        state
      else
        # Fast forward to @max_time, we've done all we can
        extra_release = (@max_time - state.time) * state.release_rate
        %{state | time: @max_time, released_amount: state.released_amount + extra_release}
      end

    if state.time >= @max_time do
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

    case {state.next, state.targets} do
      # Nothing to do, find a new move
      {[[]], [nil]} ->
        Enum.reduce(state.openable, [], fn valve, acc ->
          [at | next] = Map.get(paths, [state.at, valve.id])
          new_state = %{state | at: at, next: [next], targets: [valve]}
          [new_state | acc]
        end)

      # At a closed valve, open it
      {[[]], [valve]} ->
        [
          %{
            state
            | openable: List.delete(state.openable, valve),
              open: [valve | state.open],
              targets: [nil],
              release_rate: state.release_rate + valve.flow
          }
        ]

      # Keep walking towards the next valve
      {[[move | rest]], _targets} ->
        [%{state | at: move, next: [rest]}]
    end
  end

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
