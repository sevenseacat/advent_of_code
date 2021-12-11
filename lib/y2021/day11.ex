defmodule Y2021.Day11 do
  use Advent.Day, no: 11

  alias Y2021.Day11.Grid

  def part1(grid, steps), do: run_steps(grid, steps, 0) |> elem(1)

  def part2(grid), do: look_for_synchronization(grid, 1)

  def run_steps(grid, 0, count), do: {grid, count}

  def run_steps(grid, step, count) do
    # IO.inspect("NEW STEP!!!!!")

    {grid, count} =
      grid
      |> increase_energy()
      |> flash(count)

    run_steps(grid, step - 1, count)
  end

  def look_for_synchronization(grid, step) do
    {grid, count} =
      grid
      |> increase_energy()
      |> flash(0)

    if count == Grid.size(grid) do
      step
    else
      look_for_synchronization(grid, step + 1)
    end
  end

  defp increase_energy(%Grid{map: map}) do
    for({coord, energy} <- map, into: %{}, do: {coord, energy + 1})
    |> Grid.new()
  end

  defp reset_flashing(%Grid{map: map}) do
    for({coord, energy} <- map, into: %{}, do: {coord, if(energy >= 10, do: 0, else: energy)})
    |> Grid.new()
  end

  defp flash(%Grid{map: map} = grid, count) do
    flashing_coords =
      map
      |> Enum.filter(fn {_coord, energy} -> energy > 9 end)
      |> Enum.map(fn {coord, _energy} -> coord end)

    {grid, flashing_coords} = run_flash(grid, flashing_coords, MapSet.new())
    {reset_flashing(grid), count + MapSet.size(flashing_coords)}
  end

  def run_flash(grid, [], flashing_coords), do: {grid, flashing_coords}

  def run_flash(%Grid{map: map} = grid, to_flash, flashing_coords) do
    # IO.inspect(grid)
    # IO.inspect(to_flash, label: "running a flash loop")

    {map, to_flash, flashing_coords} =
      to_flash
      |> Enum.reduce({map, [], flashing_coords}, fn coord, {map, to_flash, flashing_coords} ->
        if MapSet.member?(flashing_coords, coord) do
          {map, to_flash, flashing_coords}
        else
          # IO.inspect(coord, label: "checking")
          # IO.inspect(Grid.new(map), label: "before\n")

          adjacent =
            adjacent_coordinates(coord, map)
            |> Enum.reject(fn {coord, _energy} -> MapSet.member?(flashing_coords, coord) end)

          # |> IO.inspect(label: "adjacent")

          to_flash =
            to_flash ++
              (Enum.filter(adjacent, fn {_coord, energy} -> energy >= 9 end)
               |> Enum.map(fn {coord, _energy} -> coord end))

          map =
            Enum.reduce(adjacent, map, fn {coord, _}, map ->
              Map.update!(map, coord, &(&1 + 1))
            end)

          # IO.inspect(Grid.new(map), label: "after\n")

          {map, to_flash, MapSet.put(flashing_coords, coord)}
        end
      end)

    grid = Grid.new(map)
    # IO.inspect(grid, label: "brother may I have some loopz\n")
    run_flash(grid, to_flash |> Enum.uniq(), flashing_coords)
  end

  defp adjacent_coordinates({row, col}, map) do
    [
      {row - 1, col - 1},
      {row - 1, col},
      {row - 1, col + 1},
      {row, col - 1},
      {row, col + 1},
      {row + 1, col - 1},
      {row + 1, col},
      {row + 1, col + 1}
    ]
    |> Enum.map(fn coord -> {coord, Map.get(map, coord)} end)
    |> Enum.filter(fn {_coord, energy} -> energy end)
  end

  def parse_input(input) do
    rows = String.split(input, "\n", trim: true)

    for {line, row} <- Enum.with_index(rows, 0),
        {number, col} <- Enum.with_index(String.graphemes(String.trim(line)), 0),
        into: %{} do
      {{row, col}, String.to_integer(number)}
    end
    |> Grid.new()
  end

  def part1_verify, do: input() |> parse_input() |> part1(100)
  def part2_verify, do: input() |> parse_input() |> part2()
end
