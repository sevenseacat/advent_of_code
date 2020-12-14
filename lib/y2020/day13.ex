defmodule Y2020.Day13 do
  use Advent.Day, no: 13

  @doc """
  iex> Day13.part1({939, [7, 13, 59, 31, 19]})
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
  iex> Day13.part2(:parsed_input)
  :ok
  """
  def part2(_input) do
    :ok
  end

  @doc """
  iex> Day13.parse_input("939\\n7,13,x,x,59,x,31,19\\n")
  {939, [7, 13, 59, 31, 19]}
  """
  def parse_input(input) do
    [time, buses] = String.split(input, "\n", trim: true)
    {String.to_integer(time), parse_buses(buses)}
  end

  defp parse_buses(input) do
    input
    |> String.split(",")
    |> Enum.filter(fn x -> x != "x" end)
    |> Enum.map(&String.to_integer/1)
  end

  def part1_verify, do: input() |> parse_input() |> part1() |> Map.get(:result)
  def part2_verify, do: input() |> parse_input() |> part2()
end
