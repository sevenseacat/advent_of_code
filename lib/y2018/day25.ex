defmodule Y2018.Day25 do
  use Advent.Day, no: 25

  def part1(input) do
    do_part1(input, 0)
  end

  defp do_part1([], count), do: count

  defp do_part1([hd | tl], count) do
    find_constellation([hd], tl)
    |> do_part1(count + 1)
  end

  defp find_constellation(current, potential) do
    {in_c, out_c} =
      Enum.split_with(potential, fn coord -> within_constellation?(coord, current) end)

    case in_c do
      [] -> out_c
      some -> find_constellation(some ++ current, out_c)
    end
  end

  defp within_constellation?(coord, constellation) do
    Enum.any?(constellation, fn c -> close_enough?(coord, c) end)
  end

  defp close_enough?([a1, b1, c1, d1], [a2, b2, c2, d2]) do
    abs(a1 - a2) + abs(b1 - b2) + abs(c1 - c2) + abs(d1 - d2) <= 3
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_row/1)
  end

  defp parse_row(row) do
    row
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  def part1_verify, do: input() |> parse_input() |> part1()
end
