defmodule Y2020.Day13 do
  use Advent.Day, no: 13

  @doc """
  iex> Day13.part1({939, [7, 13, nil, nil, 59, nil, 31, 19]})
  %{bus: 59, time: 944, result: 295}
  """
  def part1({time, buses}) do
    {bus_no, depart_time} =
      buses
      |> Enum.map(fn b -> {b, lcm_greater_than(time, b, b)} end)
      |> Enum.min_by(fn {_b, num} -> num end)

    %{bus: bus_no, time: depart_time, result: (depart_time - time) * bus_no}
  end

  defp lcm_greater_than(min, val, _inc) when val >= min, do: val
  defp lcm_greater_than(min, val, inc), do: lcm_greater_than(min, val + inc, inc)

  @doc """
  iex> Day13.part2({939, [7, 13, nil, nil, 59, nil, 31, 19]})
  1068781

  iex> Day13.part2({0, [17, nil, 13, 19]})
  3417

  iex> Day13.part2({0, [67, 7, 59, 61]})
  754018

  iex> Day13.part2({0, [67, nil, 7, 59, 61]})
  779210

  iex> Day13.part2({0, [67, 7, nil, 59, 61]})
  1261476

  iex> Day13.part2({0, [1789, 37, 47, 1889]})
  1202161486
  """
  def part2({_bus_no, buses}) do
    bus_data =
      buses
      |> Enum.with_index()
      |> Enum.filter(fn {bus, _} -> bus != nil end)

    do_part2(0, bus_data)
  end

  def do_part2(time, bus_data) do
    if Enum.all?(bus_data, fn {bus, offset} ->
         rem(time, bus) == if offset == 0, do: 0, else: bus - offset
       end) do
      time
    else
      do_part2(time + 1, bus_data)
    end
  end

  @doc """
  iex> Day13.parse_input("939\\n7,13,x,x,59,x,31,19\\n")
  {939, [7, 13, nil, nil, 59, nil, 31, 19]}
  """
  def parse_input(input) do
    [time, buses] = String.split(input, "\n", trim: true)
    {String.to_integer(time), parse_buses(buses)}
  end

  defp parse_buses(input) do
    input
    |> String.split(",")
    |> Enum.map(&if &1 == "x", do: nil, else: String.to_integer(&1))
  end

  def part1_verify, do: input() |> parse_input() |> part1() |> Map.get(:result)
  def part2_verify, do: input() |> parse_input() |> part2()
end
