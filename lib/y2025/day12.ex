defmodule Y2025.Day12 do
  use Advent.Day, no: 12

  def part1({_presents, boxes}) do
    # Each present is seven units of area, so they can't fit if the area
    # needed by the presents exceeds the area of the box.
    boxes
    |> Enum.map(fn {one, two, list} -> {one * two, Enum.sum(list) * 7} end)
    |> Enum.count(fn {size, area} -> size > area end)
  end

  def parse_input(input) do
    [boxes | presents] =
      input
      |> String.split("\n\n", trim: true)
      |> Enum.reverse()

    {presents, Enum.map(String.split(boxes, "\n", trim: true), &parse_box/1)}
  end

  defp parse_box(box) do
    [one, two | rest] =
      Regex.scan(~r/(\d+)x(\d+): (\d+) (\d+) (\d+) (\d+) (\d+) (\d+)/, box,
        capture: :all_but_first
      )
      |> hd()
      |> Enum.map(&String.to_integer/1)

    {one, two, rest}
  end

  def part1_verify, do: input() |> parse_input() |> part1()
end
