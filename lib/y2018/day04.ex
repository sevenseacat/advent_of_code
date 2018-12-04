defmodule Y2018.Day04 do
  use Advent.Day, no: 4

  @doc """
  iex> Day04.part1(%{~D[1518-11-01] => %{
  ...>   guard_no: 10,
  ...>   naps: [{~T[01:30:00], ~T[01:35:00]}, {~T[01:38:00], ~T[01:40:00]}]
  ...> }, ~D[1518-11-02] => %{
  ...>   guard_no: 99,
  ...>   naps: [{~T[01:40:00], ~T[01:50:00]}]
  ...> }, ~D[1518-11-03] => %{
  ...>   guard_no: 99,
  ...>   naps: [{~T[01:49:00], ~T[01:55:00]}]
  ...> }})
  %{guard_no: 99, total_minutes: 16, minute: 49}
  """
  def part1(input) do
    input
    |> Enum.reduce(%{}, &sleeping_minutes_per_guard/2)
    |> find_most_likely_guard
  end

  def part2(input) do
    input
    |> Enum.reduce(%{}, &sleeping_minutes_per_guard/2)
    |> find_guard_by_most_common_sleeping_minute
  end

  @doc """
  iex> Day04.sleeping_minutes_per_guard({~D[1518-11-01], %{
  ...>   guard_no: 10,
  ...>   naps: [{~T[01:30:00], ~T[01:34:00]}, {~T[01:05:00], ~T[01:10:00]}]
  ...> }}, %{})
  %{10 => [5,6,7,8,9,30,31,32,33]}
  """
  def sleeping_minutes_per_guard({_date, %{guard_no: guard_no, naps: naps}}, acc) do
    Map.update(acc, guard_no, nap_minutes(naps), &((nap_minutes(naps) ++ &1) |> Enum.sort()))
  end

  defp nap_minutes(naps) do
    naps
    |> Enum.reduce([], fn {start_time, end_time}, acc ->
      (Enum.to_list(end_time.minute..start_time.minute) |> tl) ++ acc
    end)
    |> Enum.sort()
  end

  def find_most_likely_guard(guards) do
    {guard, minutes} = Enum.max_by(guards, fn {_, minutes} -> length(minutes) end)

    %{
      guard_no: guard,
      total_minutes: length(minutes),
      minute: frequencies(minutes) |> Enum.max_by(fn {_k, v} -> v end) |> elem(0)
    }
  end

  def find_guard_by_most_common_sleeping_minute(guards) do
    guards
    |> Enum.reject(fn {_guard_no, minutes} -> minutes == [] end)
    |> Enum.map(fn {guard_no, minutes} ->
      most_common_minute = frequencies(minutes) |> Enum.max_by(fn {_k, v} -> v end)

      %{
        guard_no: guard_no,
        minute: elem(most_common_minute, 0),
        times: elem(most_common_minute, 1)
      }
    end)
    |> Enum.max_by(fn %{times: times} -> times end)
  end

  @doc """
  iex> Day04.parse_input(\"\"\"
  ...> [1518-11-01 00:00] Guard #10 begins shift
  ...> [1518-11-01 00:05] falls asleep
  ...> [1518-11-01 00:25] wakes up
  ...> [1518-11-01 00:30] falls asleep
  ...> [1518-11-01 00:55] wakes up
  ...> [1518-11-01 23:58] Guard #99 begins shift
  ...> [1518-11-02 00:40] falls asleep
  ...> [1518-11-02 00:50] wakes up
  ...> \"\"\")
  %{~D[1518-11-01] => %{
    guard_no: 10,
    starts_at: ~T[01:00:00],
    naps: [{~T[01:30:00], ~T[01:55:00]}, {~T[01:05:00], ~T[01:25:00]}]
  }, ~D[1518-11-02] => %{
    guard_no: 99,
    starts_at: ~T[00:58:00],
    naps: [{~T[01:40:00], ~T[01:50:00]}]
  }}
  """
  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.sort()
    |> Enum.reduce(Map.new(), &split_input_into_shifts/2)
  end

  defp split_input_into_shifts(row, schedule) do
    datetime =
      Regex.run(~r/(\d{4}-\d{2}-\d{2} \d{2}:\d{2})/, row, capture: :all_but_first)
      |> hd
      |> Kernel.<>(":00")
      |> NaiveDateTime.from_iso8601!()
      # To put all times on the same day, if a guard starts shift just before midnight
      |> NaiveDateTime.add(3600, :second)

    guard_no =
      case Regex.run(~r/ Guard #(\d+)/, row, capture: :all_but_first) do
        [number] -> String.to_integer(number)
        _ -> nil
      end

    Map.update(
      schedule,
      NaiveDateTime.to_date(datetime),
      %{
        guard_no: guard_no,
        starts_at: NaiveDateTime.to_time(datetime),
        naps: []
      },
      fn record ->
        # This is either a sleep or wake record, not a shift start.
        if(String.contains?(row, "falls asleep")) do
          Map.update!(record, :naps, &[{NaiveDateTime.to_time(datetime), nil} | &1])
        else
          Map.update!(record, :naps, fn [{start, nil} | rest] ->
            [{start, NaiveDateTime.to_time(datetime)} | rest]
          end)
        end
      end
    )
  end

  defp frequencies(list) do
    Enum.reduce(list, Map.new(), fn c, acc -> Map.update(acc, c, 1, &(&1 + 1)) end)
  end

  def part1_verify do
    %{guard_no: guard_no, minute: minute} = input() |> parse_input() |> part1()
    guard_no * minute
  end

  def part2_verify do
    %{guard_no: guard_no, minute: minute} = input() |> parse_input() |> part2()
    guard_no * minute
  end
end
