defmodule Y2022.Day19 do
  use Advent.Day, no: 19

  def part1(input, time \\ 24) do
    input
    |> Advent.pmap(&quality_level(&1, time), timeout: :infinity)
    |> Enum.sum()
  end

  def part2(input, time \\ 32) do
    input
    |> Enum.take(3)
    |> Advent.pmap(&run_geode_cracker(&1, time), timeout: :infinity)
    |> Enum.product()
  end

  defp quality_level(blueprint, time) do
    geode_count = run_geode_cracker(blueprint, time)
    # dbg({blueprint.id, geode_count})
    blueprint.id * geode_count
  end

  def run_geode_cracker(blueprint, time) do
    initial_state = %{
      costs: blueprint.costs ++ [{nil, %{}}],
      max_robots_needed: max_robots_needed(blueprint.costs),
      inventory: %{},
      robots: %{ore: 1}
    }

    do_search(tick(initial_state), [], time - 1, 0, MapSet.new())
  end

  defp do_search([], [], _time, best, _cache), do: best

  defp do_search([], queue, time, best, cache) do
    # IO.puts("* Level #{time - 1}: #{length(queue)} to run")
    do_search(queue, [], time - 1, best, cache)
  end

  defp do_search([state | rest], queue, time, best, cache) do
    if time == 0 do
      new_best = max(best, Map.get(state.inventory, :geode, 0))
      do_search(rest, queue, time, new_best, cache)
    else
      cache_key = {state.inventory, state.robots}

      if MapSet.member?(cache, cache_key) do
        do_search(rest, queue, time, best, cache)
      else
        next = tick(state)
        do_search(rest, enqueue(queue, next), time, best, MapSet.put(cache, cache_key))
      end
    end
  end

  defp enqueue(queue, states) do
    Enum.reduce(states, queue, fn state, queue -> [state | queue] end)
  end

  defp tick(state) do
    {updated_costs, possible_builds} = possible_builds(state)

    # Start building robots from inventory
    possible_builds
    |> Enum.map(fn {to_build, new_inventory} ->
      # Collect resources from robots
      new_inventory =
        Enum.reduce(state.robots, new_inventory, fn {type, count}, acc ->
          Map.update(acc, type, count, &(&1 + count))
        end)

      # Add built robot to inventory
      %{
        state
        | costs: updated_costs,
          inventory: new_inventory,
          robots: maybe_add_robot(state.robots, to_build)
      }
    end)
  end

  defp maybe_add_robot(robots, nil), do: robots
  defp maybe_add_robot(robots, robot), do: Map.update(robots, robot, 1, &(&1 + 1))

  defp possible_builds(%{costs: costs, inventory: inventory, robots: robots} = state) do
    # Because we can only build one robot at a time, we don't need too many of
    # any given robot except geode (always want more geode robots!)
    # eg. if it takes 10 clay to make an obsidian robot, we don't need more than
    # 10 clay robots because we can only use 10 in one minute.
    costs =
      Enum.filter(costs, fn
        {type, _cost} when type in [:geode, nil] -> true
        {type, _cost} -> Map.get(state.max_robots_needed, type) > Map.get(robots, type, 0)
      end)

    {costs,
     costs
     |> Enum.filter(fn {_type, cost} -> can_build?(cost, inventory) end)
     |> prioritize_important_robots()
     |> Enum.map(fn {type, cost} -> {type, update_inventory(cost, inventory)} end)}
  end

  defp max_robots_needed(costs) do
    Enum.reduce(costs, %{}, fn {type, _cost}, acc ->
      max =
        Enum.map(costs, fn {_dependent, cost} -> Map.get(cost, type, 0) end)
        |> Enum.max()

      Map.put(acc, type, max)
    end)
  end

  defp prioritize_important_robots([{:geode, _} = geode | _]), do: [geode]
  defp prioritize_important_robots([{:obsidian, _} = obsidian | rest]), do: [obsidian, hd(rest)]
  defp prioritize_important_robots(robots), do: Enum.take(robots, 3)

  defp update_inventory(robot_cost, inventory) do
    Enum.reduce(robot_cost, inventory, fn {component, cost}, inventory ->
      Map.update!(inventory, component, &(&1 - cost))
    end)
  end

  defp can_build?(robot_cost, inventory) do
    Enum.all?(robot_cost, fn {component, cost} ->
      Map.has_key?(inventory, component) && Map.get(inventory, component, 0) >= cost
    end)
  end

  @doc """
  iex> Day19.parse_input("Blueprint 1: Each ore robot costs 4 ore. Each clay robot costs 4 ore. Each obsidian robot costs 4 ore and 12 clay. Each geode robot costs 3 ore and 8 obsidian.\\n")
  [%{id: 1, costs: [{:geode, %{ore: 3, obsidian: 8}}, {:obsidian, %{ore: 4, clay: 12}}, {:clay, %{ore: 4}}, {:ore, %{ore: 4}}]}]
  """
  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn blueprint ->
      numbers = Regex.scan(~r/\d+/, blueprint) |> Enum.map(fn [num] -> String.to_integer(num) end)

      %{
        id: Enum.at(numbers, 0),
        costs: [
          {:geode, %{ore: Enum.at(numbers, 5), obsidian: Enum.at(numbers, 6)}},
          {:obsidian, %{ore: Enum.at(numbers, 3), clay: Enum.at(numbers, 4)}},
          {:clay, %{ore: Enum.at(numbers, 2)}},
          {:ore, %{ore: Enum.at(numbers, 1)}}
        ]
      }
    end)
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  def part2_verify, do: input() |> parse_input() |> part2()
end
