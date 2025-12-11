defmodule Y2025.Day10 do
  use Advent.Day, no: 10

  alias Dantzig.{Constraint, Polynomial, Problem}

  def part1(input) do
    input
    |> Advent.pmap(fn row ->
      find_min_presses(row.lights, row.buttons, 1)
    end)
    |> Enum.sum()
  end

  def part2(input) do
    # This can be modelled as a set of simultaneous equations!
    # eg. [.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
    #             a   b     c    d    e      f
    # can be written as e + f = 3; b + f = 5; c + d + e = 4; a + b + d = 7
    # But there are more unknowns (buttons) than results (# of lights.)
    # Plus all the numbers have to be positive.
    # Enter Dantzig!
    input
    |> Advent.pmap(fn row ->
      problem = Problem.new(direction: :minimize)

      # Set up the problem with all of the variables, one for each button
      {problem, variables} =
        Enum.reduce(
          1..length(row.buttons),
          {problem, []},
          fn num, {problem, variables} ->
            {problem, variable} =
              Problem.new_variable(problem, "#{num}", min: 0, type: :integer)

            {problem, [variable | variables]}
          end
        )

      variables = Enum.reverse(variables)

      # Add constraints - the formulas for each light value, eg. e + f = 3
      problem =
        Map.keys(row.lights)
        |> Enum.reduce(problem, fn light, problem ->
          applicable_buttons =
            Enum.zip(variables, row.buttons)
            |> Enum.filter(fn {_val, button} -> light in button end)
            |> Enum.map(&elem(&1, 0))

          constraint =
            Constraint.new(Polynomial.sum(applicable_buttons), :==, Map.get(row.joltage, light))

          Problem.add_constraint(problem, constraint)
        end)
        |> Problem.increment_objective(Polynomial.sum(variables))

      # Solve it!
      {:ok, solution} = Dantzig.solve(problem)

      solution.variables
      |> Map.values()
      |> Enum.sum()
    end)
    |> Enum.sum()
  end

  def find_min_presses(target, buttons, num) do
    initial = Map.new(target, fn {pos, _val} -> {pos, false} end)
    combos = Advent.combinations(buttons, num)

    if Enum.any?(combos, &(push_buttons(initial, &1) == target)) do
      num
    else
      find_min_presses(target, buttons, num + 1)
    end
  end

  defp push_buttons(current, buttons) do
    Enum.reduce(buttons, current, fn button, state ->
      Enum.reduce(button, state, fn pos, acc ->
        Map.update!(acc, pos, &(!&1))
      end)
    end)
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_row/1)
  end

  defp parse_row(row) do
    [lights | rest] = String.split(row, " ")
    [joltage | buttons] = Enum.reverse(rest)

    %{
      lights: parse_lights(lights),
      buttons: parse_buttons(buttons),
      joltage: parse_joltage(joltage)
    }
  end

  defp parse_lights(lights) do
    lights
    |> String.slice(1..-2//1)
    |> String.graphemes()
    |> Enum.reduce({0, %{}}, fn char, {index, acc} ->
      acc = Map.put(acc, index, char == "#")
      {index + 1, acc}
    end)
    |> elem(1)
  end

  defp parse_buttons(buttons) do
    buttons
    |> Enum.reverse()
    |> Enum.map(&parse_num_string/1)
  end

  defp parse_joltage(joltage) do
    joltage
    |> parse_num_string()
    |> Enum.reduce({0, %{}}, fn num, {index, acc} ->
      acc = Map.put(acc, index, num)
      {index + 1, acc}
    end)
    |> elem(1)
  end

  defp parse_num_string(string) do
    string
    |> String.slice(1..-2//1)
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  def part2_verify, do: input() |> parse_input() |> part2()
end
