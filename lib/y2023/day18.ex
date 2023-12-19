defmodule Y2023.Day18 do
  use Advent.Day, no: 18

  @doc """
  Use the shoelace algorithm to calculate the area of the shape dug by all of
  the trenches. https://www.101computing.net/the-shoelace-algorithm/
  Also need to account for each "point" being a 1m^3 cube, with each point being
  the middle - so we need half a m^3 for each point in the border
  And one because *shrug*
  """
  def part1(input) do
    interior =
      input
      |> Enum.reduce([{1, 1}], &dig_trench/2)
      |> tl()
      |> run_shoelace_algorithm()

    border_length =
      input
      |> Enum.map(fn {_, length, _} -> length end)
      |> Enum.sum()

    interior + div(border_length, 2) + 1
  end

  def part2(input) do
    input
    |> reparse()
    |> part1()
  end

  def run_shoelace_algorithm(coordinates) do
    do_shoelace(coordinates, {0, 0}, hd(coordinates))
  end

  defp do_shoelace([{last_row, last_col}], {sum_one, sum_two}, {first_row, first_col}) do
    sum_one = sum_one + last_row * first_col
    sum_two = sum_two + last_col * first_row
    div(sum_one - sum_two, 2)
  end

  defp do_shoelace(
         [{one_row, one_col}, {two_row, two_col} = two | rest],
         {sum_one, sum_two},
         first
       ) do
    do_shoelace([two | rest], {sum_one + one_row * two_col, sum_two + one_col * two_row}, first)
  end

  defp dig_trench({direction, length, _color}, [position | _rest] = set) do
    [move(position, direction, length) | set]
  end

  defp move({row, col}, direction, length) do
    case direction do
      "D" -> {row + length, col}
      "U" -> {row - length, col}
      "L" -> {row, col - length}
      "R" -> {row, col + length}
    end
  end

  @doc """
  iex> Day18.parse_input("R 6 (#70c710)\\nD 15 (#0dc571)")
  [{"R", 6, "#70c710"}, {"D", 15, "#0dc571"}]
  """
  def parse_input(input) do
    for row <- String.split(input, "\n", trim: true) do
      [direction, length, color] = String.split(row, " ")
      color = String.replace(color, ["(", ")"], "")
      {direction, String.to_integer(length), color}
    end
  end

  @doc """
  iex> Day18.reparse([{"R", 6, "#70c710"}, {"D", 15, "#0dc571"}])
  [{"R", 461937, nil}, {"D", 56407, nil}]
  """
  def reparse(input) do
    directions = %{"0" => "R", "1" => "D", "2" => "L", "3" => "U"}

    for {_, _, <<"#", hex::binary-5, direction::binary-1>>} <- input do
      {num, ""} = Integer.parse(hex, 16)
      {Map.fetch!(directions, direction), num, nil}
    end
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  def part2_verify, do: input() |> parse_input() |> part2()
end
