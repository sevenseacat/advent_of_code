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
    # This is a slight variation of the Chinese Remainder Theorem.
    # I didn't discover that myself. Someone mentioned the name of the algorithm on
    # Slack and off I went.
    bus_data =
      buses
      |> Enum.with_index()
      |> Enum.filter(fn {bus, _} -> bus != nil end)

    bus_nos = Enum.map(bus_data, fn {i, _} -> i end)
    offsets = Enum.map(bus_data, &get_offset/1)
    chinese_remainder(bus_nos, offsets)
  end

  defp get_offset({_bus, 0}), do: 0
  defp get_offset({bus, offset}), do: bus - offset

  # Translated from Ruby - https://rosettacode.org/wiki/Chinese_remainder_theorem#Ruby
  # Do I understand it? No. Does it work? Yep.
  defp chinese_remainder(mods, remainders) do
    max = Enum.reduce(mods, fn x, acc -> x * acc end)

    remainders
    |> Enum.zip(mods)
    |> Enum.map(fn {r, m} -> div(r * max * invmod(div(max, m), m), m) end)
    |> Enum.sum()
    |> rem(max)
  end

  defp invmod(e, et) do
    [1, x] = extended_gcd(e, et)
    rem(x + et, et)
  end

  defp extended_gcd(a, b) do
    [last_remainder, last_x] = compute_extended_gcd(abs(a), abs(b), 0, 1, 1, 0)
    [last_remainder, last_x * if(a < 0, do: -1, else: 1)]
  end

  defp compute_extended_gcd(last_remainder, 0, _, last_x, _, _), do: [last_remainder, last_x]

  defp compute_extended_gcd(last_remainder, remainder, x, last_x, y, last_y) do
    [last_remainder, quotient, remainder] = [
      remainder,
      div(last_remainder, remainder),
      rem(last_remainder, remainder)
    ]

    [x, last_x] = [last_x - quotient * x, x]
    [y, last_y] = [last_y - quotient * y, y]

    compute_extended_gcd(last_remainder, remainder, x, last_x, y, last_y)
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
