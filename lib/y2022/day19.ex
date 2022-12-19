defmodule Y2022.Day19 do
  use Advent.Day, no: 19

  @max_time 24

  def part1(input) do
    input
    |> Enum.map(&quality_level/1)
    |> Enum.sum()
  end

  # @doc """
  # iex> Day19.part2("update or delete me")
  # "update or delete me"
  # """
  # def part2(input) do
  #   input
  # end

  defp quality_level(blueprint) do
    blueprint.id * run_geode_cracker(blueprint)
  end

  def run_geode_cracker(blueprint) do
    tick(blueprint, %{ore: 1}, %{}, @max_time)
  end

  defp tick(_blueprint, _robots, inventory, 0) do
    Map.get(inventory, :geode, 0)
  end

  defp tick(blueprint, robots, inventory, time) do
    IO.puts("Time: #{@max_time - time + 1}")
    # Start building robots from inventory
    {to_build, inventory} =
      Enum.reduce(blueprint.costs, {%{}, inventory}, fn robot_cost, state ->
        build_robot(robot_cost, state)
      end)

    IO.inspect(to_build, label: "Can build")

    # Collect resources from robots
    inventory =
      Enum.reduce(robots, inventory, fn {type, count}, acc ->
        Map.update(acc, type, count, &(&1 + count))
      end)
      |> IO.inspect(label: "Inventory")

    # Add built robots to robot list
    robots =
      Enum.reduce(to_build, robots, fn {type, num}, robots ->
        Map.update(robots, type, num, &(&1 + num))
      end)

    IO.inspect(robots, label: "Robots")

    IO.puts("-----")
    tick(blueprint, robots, inventory, time - 1)
  end

  defp build_robot({robot_type, robot_cost}, {robots, inventory}) do
    case buildable_count(robot_cost, inventory) do
      0 ->
        {robots, inventory}

      n ->
        actual_cost = Enum.map(robot_cost, fn {component, cost} -> {component, cost * n} end)

        {
          Map.put(robots, robot_type, n),
          Enum.reduce(actual_cost, inventory, fn {component, cost}, inventory ->
            Map.update!(inventory, component, &(&1 - cost))
          end)
        }
    end
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
  # def part2_verify, do: input() |> parse_input() |> part2()
end
