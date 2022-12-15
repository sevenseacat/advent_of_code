defmodule Y2022.Day15 do
  use Advent.Day, no: 15

  def part1(input, row \\ 2_000_000) do
    cols = sensed_cols(input, row)

    beacon_count =
      input
      |> Enum.filter(fn %{beacon: {beacon_row, _}} -> beacon_row == row end)
      |> Enum.map(&(&1.beacon |> elem(1)))
      |> Enum.uniq()
      |> Enum.filter(fn beacon ->
        Enum.any?(cols, fn {min, max} -> beacon >= min || beacon <= max end)
      end)
      |> length

    cols
    |> Enum.map(&range_size/1)
    |> Enum.sum()
    |> Kernel.-(beacon_count)
  end

  def part2(input, max_row \\ 4_000_000) do
    # There's only going to be one square not covered by a sensor, in the entire dang grid.
    # If there's a gap in any of the sensed columns of a row (eg. two ranges are returned)
    # then that gap is the point we want.
    {row, col} =
      Enum.find_value(0..max_row, fn row ->
        case sensed_cols(input, row) do
          [_one] -> nil
          [{_, b}, {_, _}] -> {row, b + 1}
        end
      end)

    {{row, col}, col * 4_000_000 + row}
  end

  defp sensed_cols(input, row) do
    input
    |> Enum.map(&target_row_overlap(&1, row))
    |> Enum.filter(& &1)
    |> Enum.sort()
    |> collapse_ranges
  end

  defp add_manhattan_distance(%{sensor: sensor, beacon: beacon} = state) do
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
      distance_from_sensor = abs(target_row - sensor_row)

      range_start = sensor_col - distance + distance_from_sensor
      range_end = sensor_col + distance - distance_from_sensor

      {range_start, range_end}
    end
  end

  defp collapse_ranges([one]), do: [one]

  defp collapse_ranges([{a, b}, {c, d} | rest]) do
    cond do
      # Completely overlapping
      d <= b -> collapse_ranges([{a, b} | rest])
      # Partially overlapping
      c <= b -> collapse_ranges([{a, d} | rest])
      true -> [{a, b} | collapse_ranges([{c, d} | rest])]
    end
  end

  defp range_size({a, b}), do: b - a + 1

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
      |> add_manhattan_distance()
    end)
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  def part2_verify, do: input() |> parse_input() |> part2() |> elem(1)
end
