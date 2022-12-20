defmodule Y2020.Day18 do
  use Advent.Day, no: 18

  def part1(input) do
    input
    |> parse_input()
    |> Enum.map(&solve_equation/1)
    |> Enum.sum()
  end

  # @doc """
  # iex> Day18.part2("update or delete me")
  # "update or delete me"
  # """
  # def part2(input) do
  #   input
  # end

  def solve_equation({[head | tail], replacements}) do
    tail
    |> Enum.chunk_every(2)
    |> Enum.reduce(solve_val(head, replacements), &next_operator(&1, &2, replacements))
  end

  defp next_operator([op, next], acc, replacements) when op in ["*", "+"] do
    real_op = if op == "*", do: &Kernel.*/2, else: &Kernel.+/2
    real_op.(acc, solve_val(next, replacements))
  end

  defp solve_val(num, replacements) do
    case Integer.parse(num) do
      :error ->
        replacement_formula = Map.fetch!(replacements, hd(String.to_charlist(num)))
        solve_equation({replacement_formula, replacements})

      {num, _rest} ->
        num
    end
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_group({&1, %{}}))
  end

  defp parse_group({input, replacements}) do
    case Regex.scan(~r/(\([^\(\)]+\))/U, input, capture: :all_but_first) do
      [] ->
        # No brackets left!
        {String.split(input, " "), replacements}

      formulas ->
        # Moooore brackets
        next_val = Enum.max([?a | Map.keys(replacements)]) + 1

        formulas
        |> List.flatten()
        |> Enum.reduce([{input, replacements}, next_val], fn formula,
                                                             [{input, replacements}, next_val] ->
          input = String.replace(input, formula, List.to_string([next_val]))
          formula = String.replace(formula, ["(", ")"], "")
          [{input, Map.put(replacements, next_val, String.split(formula, " "))}, next_val + 1]
        end)
        |> hd()
        |> parse_group()
    end

    # case dbg(String.split(input, ~r/\(|\)/)) do
    #  [sequence] -> String.split(sequence, " ")
    #  list -> Enum.map(list, &parse_group/1)
    # end
  end

  def part1_verify, do: input() |> part1()
  # def part2_verify, do: input() |> part2()
end
