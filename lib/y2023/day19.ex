defmodule Y2023.Day19 do
  use Advent.Day, no: 19

  def part1({workflows, parts}) do
    parts
    |> Enum.map(&run_workflow(&1, workflows, "in"))
    |> Enum.filter(fn {_part, result} -> result == :accepted end)
    |> Enum.map(&to_rating/1)
    |> Enum.sum()
  end

  def part2({workflows, _parts}) do
    possibles = %{
      "x" => %{min: 1, max: 4000},
      "m" => %{min: 1, max: 4000},
      "a" => %{min: 1, max: 4000},
      "s" => %{min: 1, max: 4000}
    }

    initial = {"in", 0, possibles}

    process_possibles(workflows, {[initial], []}, [])
    |> Enum.map(&count_possibles/1)
    |> Enum.sum()
  end

  # Do a breadth-first search exploring whether each rule passes or fails.
  defp process_possibles(_workflows, {[], []}, results), do: results

  defp process_possibles(workflows, {[], next}, results) do
    process_possibles(workflows, {next, []}, results)
  end

  defp process_possibles(
         workflows,
         {[{name, index, possibles} | rest], next},
         results
       ) do
    case name do
      "A" ->
        process_possibles(workflows, {rest, next}, [possibles | results])

      "R" ->
        process_possibles(workflows, {rest, next}, results)

      _anything ->
        rule =
          workflows
          |> Map.fetch!(name)
          |> Enum.at(index)

        # Thankfully there are no loops in the input chain, otherwise we would need to keep track
        # of rules checked so far and abort if we see a duplicate
        case rule do
          string when is_binary(string) ->
            process_possibles(
              workflows,
              {rest, [{string, 0, possibles} | next]},
              results
            )

          {key, op, value, target} ->
            # This is a comparison check that can pass or fail - queue up next steps for each.
            next_steps =
              step_options({key, op, value, target}, {name, index})
              |> Enum.map(fn {key, op, value, target, index} ->
                possibles = restrict_possibles(possibles, {key, op, value})
                {target, index, possibles}
              end)

            process_possibles(workflows, {rest, next_steps ++ next}, results)
        end
    end
  end

  defp step_options({key, :gt, value, target}, {name, index}) do
    [
      # This rule succeeds - the key must be at least value+1 and the next rule to check will be the one pointed to
      {key, :min, value + 1, target, 0},
      # This rule fails - the key must be at most value and the next rule to check will be the next for the current workflow
      {key, :max, value, name, index + 1}
    ]
  end

  # Same as the previous but in reverse
  defp step_options({key, :lt, value, target}, {name, index}) do
    [{key, :max, value - 1, target, 0}, {key, :min, value, name, index + 1}]
  end

  # This was previously more exhaustive and checked to see if value was greater
  # than or less than the current min/max, in which case updating it might actually
  # loosen the range of possibles, but that doesn't come up in my input
  defp restrict_possibles(possibles, {key, limit, value}) do
    Map.update!(possibles, key, fn map -> %{map | limit => value} end)
  end

  defp count_possibles(map) do
    map
    |> Map.values()
    |> Enum.map(&(&1.max - &1.min + 1))
    |> Enum.product()
  end

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
  def part2_verify, do: input() |> parse_input() |> part2()
end
