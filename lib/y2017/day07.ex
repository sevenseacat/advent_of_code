defmodule Y2017.Day07 do
  use Advent.Day, no: 07

  alias Y2017.Day07.Program

  def part1(programs) do
    programs
    |> Enum.find(&Program.held_by_noone?(&1, programs))
  end

  def part2(programs) do
    root = part1(programs)

    leaf = find_leaf(root, programs)
    siblings = Program.siblings(leaf, programs)
    calculate_difference(leaf, siblings)
  end

  defp find_leaf(unbalanced, programs) do
    case Program.unbalanced_child_of(unbalanced, programs) do
      nil -> unbalanced
      child -> find_leaf(child, programs)
    end
  end

  def parse_input(input) do
    programs =
      input
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(&convert_to_program/1)

    programs
    |> Enum.map(&assign_stack_weight(&1, programs))
  end

  defp convert_to_program(input) do
    data = Regex.named_captures(~r/(?<name>\w+) \((?<weight>\d+)\)( -> (?<holding>.+))*/, input)

    %Program{
      name: data["name"],
      weight: String.to_integer(data["weight"]),
      holding: String.split(data["holding"], ", ", trim: true)
    }
  end

  def assign_stack_weight(program, programs) do
    %{program | stack_weight: calculate_stack_weight(program, programs)}
  end

  defp calculate_stack_weight(%Program{weight: weight, holding: []}, _), do: weight

  defp calculate_stack_weight(%Program{weight: weight, holding: holding}, programs) do
    weight +
      (holding
       |> Stream.map(&Program.find(&1, programs))
       |> Stream.map(&calculate_stack_weight(&1, programs))
       |> Enum.sum())
  end

  defp calculate_difference(program, siblings) do
    difference =
      siblings
      |> Enum.map(&(&1.stack_weight - program.stack_weight))
      |> Enum.find(&(&1 != 0))

    {program, difference}
  end

  def part1_verify, do: input() |> parse_input() |> part1() |> Map.get(:name)

  def part2_verify do
    {program, imbalance} = input() |> parse_input() |> part2()
    program.weight + imbalance
  end
end
