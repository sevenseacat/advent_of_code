defmodule Y2019.Day13 do
  use Advent.Day, no: 13

  alias Y2019.Day05

  def part1(input) do
    {:halt, {_program, outputs}} = Day05.run_program(input)

    outputs
    |> Enum.chunk_every(3)
    |> Enum.count(fn [_, _, id] -> id == 2 end)
  end

  def part1_verify, do: input() |> Day05.parse_input() |> part1()
end
