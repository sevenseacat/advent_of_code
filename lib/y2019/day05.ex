defmodule Y2019.Day05 do
  use Advent.Day, no: 5

  alias Y2019.Intcode

  def parts(program, input) do
    program
    |> Intcode.new(List.wrap(input))
    |> Intcode.run()
    |> Intcode.outputs()
  end

  def part1_verify, do: input() |> Intcode.from_string() |> parts(1) |> List.last()
  def part2_verify, do: input() |> Intcode.from_string() |> parts(5) |> List.last()
end
