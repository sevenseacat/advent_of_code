defmodule Y2022.Day19 do
  use Advent.Day, no: 19

  def part1(input, time \\ 24) do
    input
    |> Enum.map(&quality_level(&1, time))
    |> Enum.sum()
  end

  def part2(input, time \\ 32) do
    input
    |> Enum.take(3)
    |> Enum.map(&run_geode_cracker(&1, time))
    |> Enum.product()
  end

  defp quality_level(blueprint, time) do
    geode_count = run_geode_cracker(blueprint, time)
    # dbg({blueprint.id, geode_count})
    blueprint.id * geode_count
  end

  def run_geode_cracker(blueprint, time) do
    initial_state = %{costs: blueprint.costs, inventory: %{}, robots: %{ore: 1}}
    do_search([tick(initial_state)], [], time - 1, 0, MapSet.new())
  end

  defp do_search([], [], _time, best, _cache), do: best

  defp do_search([], next_level_states, time, best, cache) do
    IO.puts("* Level #{time - 1}")
    do_search(next_level_states, [], time - 1, best, cache)
  end

  defp do_search([[] | rest], next_level_states, time, best, cache) do
    do_search(rest, next_level_states, time, best, cache)
  end

  defp do_search([[state | rest1] | rest2], next_level_states, time, best, cache) do
    if time == 0 do
      new_best = max(best, Map.get(state.inventory, :geode, 0))
      do_search([rest1 | rest2], next_level_states, time, new_best, cache)
    else
      cache_key = %{inventory: state.inventory, robots: state.robots}

      if MapSet.member?(cache, cache_key) do
        do_search([rest1 | rest2], next_level_states, time, best, cache)
      else
        do_search(
          [rest1 | rest2],
          [tick(state) | next_level_states],
          time,
          best,
          MapSet.put(cache, cache_key)
        )
      end
    end
  end

  defp tick(%{costs: costs, robots: robots, inventory: inventory}) do
    costs
    # Start building robots from inventory
    |> possible_builds(inventory)
    |> Enum.take(3)
    |> Enum.map(fn {to_build, new_inventory} ->
      # Collect resources from robots
      new_inventory =
        Enum.reduce(robots, new_inventory, fn {type, count}, acc ->
          Map.update(acc, type, count, &(&1 + count))
        end)

      # Add built robots to robot list
      robots =
        Enum.reduce(to_build, robots, fn {type, num}, robots ->
          Map.update(robots, type, num, &(&1 + num))
        end)

      %{costs: costs, robots: robots, inventory: new_inventory}
    end)
  end

  defp possible_builds([], inventory), do: [{%{}, inventory}]

  defp possible_builds([{type, cost} | rest], inventory) do
    if buildable_count(cost, inventory) > 0 do
      [{%{type => 1}, build_robot({type, 1}, cost, inventory)} | possible_builds(rest, inventory)]
    else
      possible_builds(rest, inventory)
    end
  end

  defp build_robot({_type, num}, cost_per_robot, inventory) do
    actual_cost = Enum.map(cost_per_robot, fn {component, cost} -> {component, cost * num} end)

    Enum.reduce(actual_cost, inventory, fn {component, cost}, inventory ->
      Map.update!(inventory, component, &(&1 - cost))
    end)
  end

  defp buildable_count(robot_cost, inventory) do
    robot_cost
    |> Enum.map(fn {component, cost} -> div(Map.get(inventory, component, 0), cost) end)
    |> Enum.min()
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
