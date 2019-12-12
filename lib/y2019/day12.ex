defmodule Y2019.Day12 do
  use Advent.Day, no: 12
  alias Y2019.Day12.Moon

  @moons [{1, 4, 4}, {-4, -1, 19}, {-15, -14, 12}, {-17, 1, 10}]

  def part1(moons \\ @moons, steps \\ 1000) do
    moons
    |> do_parts(steps)
    |> calculate_energy
  end

  def part2(moons \\ @moons) do
    # -1 to run infinitely until the looping is done
    do_parts(moons, -1, {MapSet.new(), MapSet.new(), MapSet.new(), nil, nil, nil})
  end

  def do_parts(moons, steps, status \\ nil) do
    [:a, :b, :c, :d]
    |> Enum.zip(Enum.map(moons, &Moon.new/1))
    |> Enum.into(%{})
    |> run_movements(0, steps, status)
  end

  defp calculate_energy(moons) do
    moons
    |> Enum.map(&Moon.energy/1)
    |> Enum.sum()
  end

  defp run_movements(_, _, -1, {_, _, _, x, y, z})
       when x != nil and y != nil and z != nil do
    {x, y, z}
  end

  defp run_movements(moons, step, step, _), do: moons

  defp run_movements(moons, step, max_steps, status) do
    new_moons =
      moons
      |> Map.keys()
      |> Advent.permutations(2)
      |> no_dupe_comparisons
      |> Enum.reduce(moons, &Moon.update_velocities/2)
      |> Moon.update_positions()

    run_movements(new_moons, step + 1, max_steps, update_status(new_moons, status, step))
  end

  # Part 1 needs no status checking
  defp update_status(_moons, nil, _step), do: nil

  # Part 2 - some really hacky shit here
  # Repeating moon data means x,y,z and a,b,c(velocity) for every moon are all the same
  # x is a function of a, y is a function of b, z is a function of c
  # Store each {x,a} (etc.) value for each moon on each step to see when it starts looping
  # When all three parameters ({x,a}, {y,b}, {z,c}) have looped, return the steps that they loop at
  # The actual result will be the lowest common multiple of the three step numbers
  defp update_status(
         moons,
         {seen_x, seen_y, seen_z, x, y, z},
         step
       ) do
    {seen_x, new_x} = check_if_seen(moons, x, seen_x, step, 0)
    {seen_y, new_y} = check_if_seen(moons, y, seen_y, step, 1)
    {seen_z, new_z} = check_if_seen(moons, z, seen_z, step, 2)
    {seen_x, seen_y, seen_z, new_x, new_y, new_z}
  end

  defp check_if_seen(_, seen_at, _, _, _) when seen_at != nil do
    {nil, seen_at}
  end

  defp check_if_seen(moons, nil, seen, step, index) do
    new_seen =
      Enum.map(moons, fn {_id, moon} ->
        {
          moon |> Map.get(:position) |> elem(index),
          moon |> Map.get(:velocity) |> elem(index)
        }
      end)

    if MapSet.member?(seen, new_seen) do
      {nil, step}
    else
      {MapSet.put(seen, new_seen), nil}
    end
  end

  # Filter out duplicate comparisons, eg. no need to compare a and b and then b and a
  defp no_dupe_comparisons(list) do
    Enum.reduce(list, [], fn [a, b], list ->
      if [b, a] in list, do: list, else: [[a, b] | list]
    end)
  end

  def part1_verify, do: part1()
  def part2_verify, do: part2() |> Tuple.to_list() |> Advent.lowest_common_multiple()
end
