defmodule Y2016.Day23 do
  use Advent.Day, no: 23

  alias Y2016.Day12

  def part1_verify do
    input() |> Day12.parse_input() |> Day12.run_assembunny_code({7, 0, 0, 0}) |> elem(0)
  end

  def part2_verify do
    input() |> Day12.parse_input() |> Day12.run_assembunny_code({12, 0, 0, 0}) |> elem(0)
  end
end
