defmodule Y2024.Day24 do
  use Advent.Day, no: 24

  def part1({start, rules}) do
    fill_in_values({start, rules})
    |> Enum.filter(fn {name, _val} -> String.starts_with?(name, "z") end)
    |> Enum.sort()
    |> Enum.reverse()
    |> Enum.map(fn {_name, val} -> val end)
    |> Integer.undigits(2)
  end

  # @doc """
  # iex> Day24.part2("update or delete me")
  # "update or delete me"
  # """
  # def part2(input) do
  #   input
  # end

  defp fill_in_values({start, []}), do: start

  defp fill_in_values({start, rules}) do
    Enum.reduce(rules, {start, []}, &fill_value/2)
    |> fill_in_values()
  end

  defp fill_value({in1, op, in2, out} = rule, {filled, rules}) do
    if Map.has_key?(filled, in1) && Map.has_key?(filled, in2) do
      {Map.put(filled, out, eval_rule(filled[in1], op, filled[in2])), rules}
    else
      {filled, [rule | rules]}
    end
  end

  defp eval_rule(one, "AND", two), do: Bitwise.band(one, two)
  defp eval_rule(one, "OR", two), do: Bitwise.bor(one, two)
  defp eval_rule(one, "XOR", two), do: Bitwise.bxor(one, two)

  def parse_input(input) do
    [starts, rules] = String.split(input, "\n\n", trim: true)
    {parse_starts(starts), parse_rules(rules)}
  end

  defp parse_starts(starts) do
    starts
    |> String.split("\n")
    |> Map.new(fn <<name::binary-size(3), ": ", num::binary-size(1)>> ->
      {name, String.to_integer(num)}
    end)
  end

  defp parse_rules(rules) do
    rules
    |> String.split("\n", trim: true)
    |> Enum.map(fn rule ->
      Regex.run(~r/(\w{3}) (AND|OR|XOR) (\w{3}) -> (\w{3})/, rule, capture: :all_but_first)
      |> List.to_tuple()
    end)
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  # def part2_verify, do: input() |> parse_input() |> part2()
end
