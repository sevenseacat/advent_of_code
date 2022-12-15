defmodule Y2022.Day15 do
  use Advent.Day, no: 15

  def part1(input, row \\ 2_000_000) do
    beacons =
      input
      |> Enum.filter(fn %{beacon: {beacon_row, _}} -> beacon_row == row end)
      |> Enum.map(&(&1.beacon |> elem(0)))
      |> MapSet.new()

    input
    |> Enum.map(&add_manhattan_distances/1)
    |> Enum.map(&target_row_overlap(&1, row))
    |> Enum.filter(& &1)
    |> Enum.map(&MapSet.new/1)
    |> Enum.reduce(&MapSet.union/2)
    |> MapSet.difference(beacons)
    |> MapSet.size()
  end

  def part2(input, {max_row, max_col} \\ {4_000_000, 4_000_000}) do
    input = Enum.map(input, &add_manhattan_distances/1)
    # There's only going to be one square not covered by a sensor, in the entire dang grid.
    # It has to be just outside one of the sensor's sense ranges, so iterate over them and find it?
    {row, col} =
      Enum.find_value(input, fn record ->
        look_for_uncovered_coord(record, {0, 0}, {max_row, max_col}, input)
      end)

    {{row, col}, col * 4_000_000 + row}
  end

  defp look_for_uncovered_coord(
         %{sensor: {row, col}, distance: distance},
         {min_row, min_col},
         {max_row, max_col},
         all
       ) do
    # Look *outside* the range - increase the distance
    distance = distance + 1

    Enum.find_value(0..distance, fn d ->
      # These are all the coordinates sliding along the boundaries of the sensor range...
      # These took me way too long to figure out
      [
        {row - d, col - distance + d},
        {row + d, col - distance + d},
        {row - d, col + distance - d},
        {row + d, col + distance - d},
        {row - distance + d, col - d},
        {row - distance + d, col + d},
        {row + distance - d, col - d},
        {row + distance - d, col + d}
      ]
      |> Enum.find_value(fn {maybe_row, maybe_col} ->
        cond do
          # Outside our valid range, go away
          maybe_row < min_row || maybe_row > max_row || maybe_col < min_col ||
              maybe_col > max_col ->
            nil

          # There's a sensor here, go away
          Enum.any?(all, fn record ->
            overlapping?(record.sensor, {maybe_row, maybe_col}, record.distance)
          end) ->
            nil

          # !!!!!!
          true ->
            {maybe_row, maybe_col}
        end
      end)
    end)
  end

  defp add_manhattan_distances(%{sensor: sensor, beacon: beacon} = state) do
    Map.put(state, :distance, manhattan_distance(sensor, beacon))
  end

  defp manhattan_distance({row1, col1}, {row2, col2}) do
    abs(row1 - row2) + abs(col1 - col2)
  end

  defp target_row_overlap(
         %{sensor: {sensor_row, sensor_col}, distance: distance},
         target_row
       ) do
    if overlapping?({sensor_row, sensor_col}, {target_row, sensor_col}, distance) do
      # There is some overlap for this beacon.
      distance_from_sensor = abs(abs(target_row) - abs(sensor_row))

      range_start = sensor_col - distance + distance_from_sensor
      range_end = sensor_col + distance - distance_from_sensor

      range_start..range_end
    end
  end

  defp overlapping?(sensor, target, distance), do: manhattan_distance(sensor, target) <= distance

  def parse_input(input) do
    Regex.scan(
      ~r/Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)/,
      input,
      capture: :all_but_first
    )
    |> Enum.map(fn record ->
      [sensor_col, sensor_row, beacon_col, beacon_row] = Enum.map(record, &String.to_integer/1)
      %{sensor: {sensor_row, sensor_col}, beacon: {beacon_row, beacon_col}}
    end)
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  def part2_verify, do: input() |> parse_input() |> part2() |> elem(1)
end
