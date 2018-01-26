defmodule Y2017.Day21.Rule do
  alias __MODULE__

  defstruct input: nil, alternates: nil, output: nil

  def matching(chunk, rules) do
    primary_match(chunk, rules) || alternate_match(chunk, rules)
  end

  defp primary_match(chunk, rules) do
    Enum.find(rules, fn rule -> rule.input == chunk end)
  end

  defp alternate_match(chunk, rules) do
    Enum.find(rules, fn rule -> Enum.member?(rule.alternates, chunk) end)
  end

  def new([input, output]) do
    %Rule{input: input, output: output}
    |> calculate_alternates
  end

  def calculate_alternates(%Rule{} = rule) do
    vertical = flip_vertical(rule.input)
    horizontal = flip_horizontal(rule.input)
    size = String.length(hd(rule.input))

    %{
      rule
      | alternates:
          ([vertical] ++
             rotations(vertical, size, 3) ++
             [horizontal] ++
             rotations(horizontal, size, 3) ++
             rotations(rule.input, size, 3))
          |> Enum.uniq()
          |> Enum.sort()
          |> Enum.reject(&(&1 == rule.input))
    }
  end

  defp flip_horizontal(input), do: Enum.map(input, &String.reverse(&1))
  defp flip_vertical(input), do: Enum.reverse(input)

  defp rotations(_, _, 0), do: []

  defp rotations(input, size, counter) do
    new_input = Enum.map(1..size, &new_row(input, &1 - 1))
    [new_input | rotations(new_input, size, counter - 1)]
  end

  defp new_row(input, index) do
    input
    |> Enum.map(&String.at(&1, index))
    |> Enum.join()
    |> String.reverse()
  end
end
