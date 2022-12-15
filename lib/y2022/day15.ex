defmodule Y2022.Day15 do
  use Advent.Day, no: 15

  def part1(input, row \\ 2_000_000) do
    beacons = Enum.map(input, & &1.beacon) |> MapSet.new()

    input
    |> Enum.map(&no_beacon_coords/1)
    |> Enum.reduce(MapSet.new(), &MapSet.union/2)
    |> MapSet.difference(beacons)
    # |> draw_grid(input, row)
    |> Enum.filter(fn {coord_row, _coord_col} -> coord_row == row end)
    |> length
  end

  # @doc """
  # iex> Day15.part2("update or delete me")
  # "update or delete me"
  # """
  # def part2(input) do
  #   input
  # end

  def no_beacon_coords(%{sensor: {s_row, s_col}, beacon: {b_row, b_col}}) do
    distance = abs(s_row - b_row) + abs(s_col - b_col)

    for(
      row <- -distance..distance,
      col <- -diff(distance, row)..diff(distance, row),
      do: {s_row + row, s_col + col}
    )
    |> MapSet.new()
  end

  defp diff(a, b), do: abs(abs(a) - abs(b))

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

  def draw_grid(no_beacons, inputs, row) do
    beacons = Enum.map(inputs, & &1.beacon)
    sensors = Enum.map(inputs, & &1.sensor)

    for(col <- -12..35, do: {row, col})
    |> Enum.map(fn coord ->
      cond do
        coord in beacons -> "B"
        coord in sensors -> "S"
        coord in no_beacons -> "#"
        true -> " "
      end
    end)
    |> Enum.chunk_every(48)
    |> Enum.map(fn row ->
      row
      |> Enum.join("")
      |> IO.puts()
    end)

    no_beacons
  end

  # def part1_verify, do: input() |> parse_input() |> part1()
  # def part2_verify, do: input() |> parse_input() |> part2()
end
