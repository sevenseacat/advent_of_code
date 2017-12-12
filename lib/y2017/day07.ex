defmodule Y2017.Day07 do
  use Advent.Day, no: 07

  alias Y2017.Day07.Program

  def part1(programs) do
    programs
    |> Enum.find(&Program.held_by_noone?(&1, programs))
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&convert_to_program/1)
  end

  defp convert_to_program(input) do
    data = Regex.named_captures(~r/(?<name>\w+) \((?<weight>\d+)\)( -> (?<holding>.+))*/, input)

    %Program{
      name: data["name"],
      weight: String.to_integer(data["weight"]),
      holding: String.split(data["holding"], ", ", trim: true)
    }
  end

  def part1_verify, do: input() |> parse_input() |> part1() |> Map.get(:name)
end
