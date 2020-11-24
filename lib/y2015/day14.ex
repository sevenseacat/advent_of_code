defmodule Y2015.Day14 do
  use Advent.Day, no: 14

  @doc """
  iex> Day14.part1("Comet can fly 14 km/s for 10 seconds, but then must rest for 127 seconds.
  ...> Dancer can fly 16 km/s for 11 seconds, but then must rest for 162 seconds.", 1000)
  [{"Comet", 1120}]
  """
  def part1(input, max_time \\ 2503) do
    results =
      input
      |> parse_input
      |> Enum.map(&distance_travelled(&1, max_time))
      |> Enum.sort_by(fn {_name, distance} -> -distance end)

    winning_distance = hd(results) |> elem(1)

    Enum.take_while(results, fn {_name, distance} -> distance == winning_distance end)
  end

  def part2(input) do
    1..2503
    |> Enum.map(fn distance -> part1(input, distance) end)
    |> List.flatten()
    |> Enum.group_by(fn {name, _distance} -> name end)
    |> Enum.map(fn {name, rows} -> {name, length(rows)} end)
    |> Enum.sort_by(fn {_name, wins} -> -wins end)
    |> hd
  end

  defp distance_travelled(stats, max_time) do
    distance = run_race(stats, 0, max_time, 0, :race)
    {elem(stats, 0), distance}
  end

  defp run_race({_name, speed, duration, _wait} = stats, time, max_time, distance, :race) do
    # lets goooooo
    if time + duration >= max_time do
      # end of race
      distance + (max_time - time) * speed
    else
      # go go go go go
      run_race(stats, time + duration, max_time, distance + duration * speed, :wait)
    end
  end

  defp run_race({_name, _speed, _duration, wait} = stats, time, max_time, distance, :wait) do
    if time + wait > max_time do
      distance
    else
      run_race(stats, time + wait, max_time, distance, :race)
    end
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&parse_row/1)
  end

  @doc """
  iex> Day14.parse_row("Dancer can fly 16 km/s for 11 seconds, but then must rest for 162 seconds.")
  {"Dancer", 16, 11, 162}
  """
  def parse_row(row) do
    [[_string, name, speed, duration, rest]] =
      Regex.scan(
        ~r/(\w+) can fly (\d+) km\/s for (\d+) seconds, but then must rest for (\d+) seconds./,
        row
      )

    {name, String.to_integer(speed), String.to_integer(duration), String.to_integer(rest)}
  end

  def part1_verify, do: input() |> part1() |> hd |> elem(1)
  def part2_verify, do: input() |> part2() |> elem(1)
end
