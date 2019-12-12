defmodule Y2019.Day12 do
  use Advent.Day, no: 12
  alias Y2019.Day12.Moon

  @moons [{1, 4, 4}, {-4, -1, 19}, {-15, -14, 12}, {-17, 1, 10}]

  def part1(moons \\ @moons, steps \\ 1000) do
    moons
    |> do_part1(steps)
    |> calculate_energy
  end

  def do_part1(moons, steps) do
    [:a, :b, :c, :d]
    |> Enum.zip(Enum.map(moons, &Moon.new/1))
    |> Enum.into(%{})
    |> run_movements(0, steps)
  end

  defp calculate_energy(moons) do
    moons
    |> Enum.map(&Moon.energy/1)
    |> Enum.sum()
  end

  defp run_movements(moons, step, step), do: moons

  defp run_movements(moons, step, max_steps) do
    moons
    |> Map.keys()
    |> Advent.permutations(2)
    |> no_dupe_comparisons
    |> Enum.reduce(moons, &Moon.update_velocities/2)
    |> Moon.update_positions()
    |> run_movements(step + 1, max_steps)
  end

  # Filter out duplicate comparisons, eg. no need to compare a and b and then b and a
  defp no_dupe_comparisons(list) do
    Enum.reduce(list, [], fn [a, b], list ->
      if [b, a] in list, do: list, else: [[a, b] | list]
    end)
  end

  def part1_verify, do: part1()
end
