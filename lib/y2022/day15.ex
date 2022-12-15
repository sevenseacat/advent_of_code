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

  # @doc """
  # iex> Day15.part2("update or delete me")
  # "update or delete me"
  # """
  # def part2(input) do
  #   input
  # end

  defp add_manhattan_distances(%{sensor: {s_row, s_col}, beacon: {b_row, b_col}} = state) do
    distance = abs(s_row - b_row) + abs(s_col - b_col)
    Map.put(state, :distance, distance)
  end

  defp target_row_overlap(%{sensor: {sensor_row, sensor_col}, distance: distance}, target_row) do
    if sensor_row - distance <= target_row && sensor_row + distance >= target_row do
      # There is some overlap for this beacon.
      distance_from_sensor = abs(abs(target_row) - abs(sensor_row))

      range_start = sensor_col - distance + distance_from_sensor
      range_end = sensor_col + distance - distance_from_sensor

      range_start..range_end
    end
  end

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
  # def part2_verify, do: input() |> parse_input() |> part2()
end
