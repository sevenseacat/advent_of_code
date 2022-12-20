defmodule Y2020.Day18 do
  use Advent.Day, no: 18

  import Kernel, except: [-: 2, *: 2, /: 2]
  import Y2020.Day18.ScrewyOperators, warn: false

  # For part 1, they need the same precedence
  # Use * and / as they have the same precedence IRL (but they are overridden to
  # have the functionality we want)
  def part1(input), do: do_parts(input, %{"+" => "*", "*" => "/"})

  # For part 2, the precedence should be flipped
  # So flip the operators (but they have been overridden to have the behaviour we want)
  def part2(input), do: do_parts(input, %{"+" => "*", "*" => "-"})

  defp do_parts(input, overridden_operators) do
    input
    |> parse_input(overridden_operators)
    |> Enum.map(fn string -> Code.eval_string(string, [], __ENV__) |> elem(0) end)
    |> Enum.sum()
  end

  def parse_input(input, operator_replacements) do
    Enum.reduce(operator_replacements, input, fn {from, to}, acc ->
      String.replace(acc, from, to)
    end)
    |> String.split("\n", trim: true)
  end

  def part1_verify, do: input() |> part1()
  def part2_verify, do: input() |> part2()
end
