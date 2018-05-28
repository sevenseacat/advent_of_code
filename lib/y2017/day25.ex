defmodule Y2017.Day25 do
  use Advent.Day, no: 25

  def part1(rules, step_count \\ 6, state \\ :A) do
    do_part1(rules, :array.new(default: 0), :array.new(default: 0), state, 0, 1, step_count)
    |> count_ones
  end

  defp do_part1(_, neg, pos, _, _, step, max_steps) when step > max_steps, do: {neg, pos}

  defp do_part1(rules, negatives, positives, state, position, step, max_steps) do
    old_val = current_val(position, negatives, positives)

    {new_val, move, new_state} = get_rule(rules, state, old_val)
    {negatives, positives} = set_value(negatives, positives, position, new_val)

    do_part1(rules, negatives, positives, new_state, move.(position), step + 1, max_steps)
  end

  defp count_ones({one, two}) do
    count_ones(one) + count_ones(two)
  end

  defp count_ones(array), do: :array.to_list(array) |> Enum.sum()

  def rules do
    %{
      A: {{1, &r/1, :B}, {0, &l/1, :C}},
      B: {{1, &l/1, :A}, {1, &r/1, :C}},
      C: {{1, &r/1, :A}, {0, &l/1, :D}},
      D: {{1, &l/1, :E}, {1, &l/1, :C}},
      E: {{1, &r/1, :F}, {1, &r/1, :A}},
      F: {{1, &r/1, :A}, {1, &r/1, :E}}
    }
  end

  def l(val), do: val - 1
  def r(val), do: val + 1

  defp current_val(position, negatives, positives) do
    if position >= 0 do
      :array.get(position, positives)
    else
      :array.get(abs(position), negatives)
    end
  end

  defp get_rule(rules, state, value) do
    rules
    |> Map.fetch!(state)
    |> elem(value)
  end

  def set_value(negatives, positives, position, value) do
    positives = if position >= 0, do: :array.set(position, value, positives), else: positives
    negatives = if position >= 0, do: negatives, else: :array.set(abs(position), value, negatives)

    {negatives, positives}
  end

  def part1_verify, do: part1(rules(), 12_134_527)
end
