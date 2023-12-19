defmodule Y2023.Day19 do
  use Advent.Day, no: 19

  def part1({workflows, parts}) do
    parts
    |> Enum.map(&run_workflow(&1, workflows, "in"))
    |> Enum.filter(fn {_part, result} -> result == :accepted end)
    |> Enum.map(&to_rating/1)
    |> Enum.sum()
  end

  # @doc """
  # iex> Day19.part2("update or delete me")
  # "update or delete me"
  # """
  # def part2(input) do
  #   input
  # end

  defp run_workflow(part, workflows, rule_name) do
    {:ok, rules} = Map.fetch(workflows, rule_name)

    case check_rules(rules, part) do
      "A" -> {part, :accepted}
      "R" -> {part, :rejected}
      result -> run_workflow(part, workflows, result)
    end
  end

  defp check_rules(rules, part) do
    Enum.find_value(rules, fn
      {key, op, value, to} -> if cmp(part, {key, op, value}), do: to
      string when is_binary(string) -> string
    end)
  end

  defp cmp(part, {key, op, value}) do
    part_value = Map.fetch!(part, key)

    case op do
      :gt -> part_value > value
      :lt -> part_value < value
    end
  end

  defp to_rating({part, :accepted}) do
    Map.values(part) |> Enum.sum()
  end

  def parse_input(input) do
    [workflows, parts] = String.split(input, "\n\n", trim: true)
    {parse_workflows(workflows), parse_parts(parts)}
  end

  defp parse_workflows(workflows) do
    for workflow <- String.split(workflows, "\n", trim: true), into: %{} do
      [name | rules] = String.split(workflow, ["{", ",", "}"])

      rules =
        Enum.reduce(rules, [], fn rule, acc ->
          cond do
            String.contains?(rule, ":") ->
              [key, num, to] = String.split(rule, ["<", ">", ":"])
              op = if String.contains?(rule, "<"), do: :lt, else: :gt
              [{key, op, String.to_integer(num), to} | acc]

            rule == "" ->
              Enum.reverse(acc)

            true ->
              [rule | acc]
          end
        end)

      {name, rules}
    end
  end

  defp parse_parts(parts) do
    for part <- String.split(parts, "\n", trim: true) do
      Regex.named_captures(~r/{x=(?<x>\d+),m=(?<m>\d+),a=(?<a>\d+),s=(?<s>\d+)}/, part)
      |> Enum.map(fn {key, value} -> {key, String.to_integer(value)} end)
      |> Map.new()
    end
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  # def part2_verify, do: input() |> parse_input() |> part2()
end
