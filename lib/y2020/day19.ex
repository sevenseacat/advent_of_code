defmodule Y2020.Day19 do
  use Advent.Day, no: 19

  @rule 0

  def part1(%{rules: rules, messages: messages}, rule \\ @rule) do
    messages
    |> Enum.count(fn message ->
      depth_first_search_for_match([{[rule], String.graphemes(message)}], rules)
    end)
  end

  def depth_first_search_for_match([], _rules), do: false
  def depth_first_search_for_match([{[], []} | _rest], _rules), do: true

  def depth_first_search_for_match([{[r1 | r2], [m1 | m2] = message} | rest], rules) do
    case r1 do
      # The cases when we've matched on a letter first
      x when is_binary(x) and x == m1 ->
        depth_first_search_for_match([{r2, m2} | rest], rules)

      x when is_binary(x) ->
        depth_first_search_for_match(rest, rules)

      # The case where we need to expand a number
      x ->
        next_steps =
          rules
          |> Map.fetch!(x)
          |> Enum.map(&{&1 ++ r2, message})

        depth_first_search_for_match(next_steps ++ rest, rules)
    end
  end

  def depth_first_search_for_match([{_, _} | rest], rules) do
    depth_first_search_for_match(rest, rules)
  end

  # @doc """
  # iex> Day19.part2("update or delete me")
  # "update or delete me"
  # """
  # def part2(input) do
  #   input
  # end

  def parse_input(input) do
    [rules, messages] = String.split(input, "\n\n", trim: true)
    %{rules: parse_rules(rules), messages: parse_messages(messages)}
  end

  defp parse_rules(rules) do
    rules
    |> String.split("\n", trim: true)
    |> Enum.reduce(%{}, &parse_rule/2)
  end

  defp parse_rule(rule, acc) do
    [num, opts] = String.split(rule, ": ", parts: 2)

    groups =
      opts
      |> String.split(" | ")
      |> Enum.map(fn group ->
        group
        |> String.split(" ")
        |> Enum.map(&parse_val/1)
      end)

    Map.put(acc, String.to_integer(num), groups)
  end

  defp parse_val(val) do
    case Integer.parse(val) do
      :error -> String.trim(val, "\"")
      {num, _rest} -> num
    end
  end

  defp parse_messages(messages) do
    String.split(messages, "\n", trim: true)
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  # def part2_verify, do: input() |> parse_input() |> part2()
end
