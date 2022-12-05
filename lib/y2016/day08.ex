defmodule Y2016.Day08 do
  use Advent.Day, no: 8

  @screen_width 50
  @screen_height 6

  @doc """
  iex> Day08.final_arrangement(["rect 3x2", "rotate column x=1 by 1",
  ...>   "rotate row y=0 by 4", "rotate column x=1 by 1"], 7, 3)
  [".#..#.#", "#.#....", ".#....."]
  """
  def final_arrangement(input, width \\ @screen_width, height \\ @screen_height) do
    input
    |> Enum.map(&String.split/1)
    |> Enum.reduce(blank_screen(width, height), &process_line/2)
  end

  def part2(input) do
    # Arranges the input and then displays it nicely.
    input
    |> final_arrangement
    |> Enum.join("\n")
    |> IO.puts()
  end

  @doc """
  iex> Day08.lit_pixel_count([".#..#.#", "#.#....", ".#....."])
  6
  """
  def lit_pixel_count(state) do
    state
    # Stolen from https://www.rosettacode.org/wiki/Count_occurrences_of_a_substring#Elixir because I am lazy.
    |> Stream.map(fn line -> length(String.split(line, "#")) - 1 end)
    |> Enum.sum()
  end

  def parse_input do
    input() |> String.split("\n")
  end

  @doc """
  iex> Day08.process_line(["rect", "3x2"], [".......", ".......", "......."])
  ["###....", "###....", "......."]

  iex> Day08.process_line(["rect", "3x2"], [".#.....", ".#....#", ".....#."])
  ["###....", "###...#", ".....#."]

  iex> Day08.process_line(["rotate", "row", "y=0", "by", "2"], [".......", ".......", "......."])
  [".......", ".......", "......."]

  iex> Day08.process_line(["rotate", "row", "y=0", "by", "2"], ["#..#...", "#....#.", "......#"])
  ["..#..#.", "#....#.", "......#"]

  iex> Day08.process_line(["rotate", "row", "y=1", "by", "3"], ["#..#...", "#....#.", "......#"])
  ["#..#...", ".#.#...", "......#"]

  iex> Day08.process_line(["rotate", "column", "x=0", "by", "2"], [".......", ".......", "......."])
  [".......", ".......", "......."]

  iex> Day08.process_line(["rotate", "column", "x=0", "by", "2"], ["#..#...", "#....#.", "......#"])
  ["#..#...", ".....#.", "#.....#"]
  """
  def process_line(["rect", size], state) do
    [x, y] = String.split(size, "x") |> Enum.map(&String.to_integer/1)
    process_rect_lines(state, {x, y}, 1)
  end

  def process_line(["rotate", "row", "y=" <> row_no, "by", count], state) do
    process_row_rotate_lines(state, {String.to_integer(row_no), String.to_integer(count)}, 0)
  end

  def process_line(["rotate", "column", "x=" <> column_no, "by", count], state) do
    column_no = String.to_integer(column_no)

    column =
      for(i <- 0..(length(state) - 1), do: state |> Enum.at(i) |> String.at(column_no))
      |> to_string
      |> rotate_string(String.to_integer(count))
      |> String.graphemes()

    process_column_rotate_lines(state, column, column_no)
  end

  defp process_rect_lines([], _, _), do: []
  defp process_rect_lines(state, {_x, y}, current_line_no) when current_line_no > y, do: state

  defp process_rect_lines([line | lines], {x, y}, current_line_no) do
    {_old, rest} = String.split_at(line, x)
    new_line = (String.duplicate("#", x) |> to_string) <> rest
    [new_line | process_rect_lines(lines, {x, y}, current_line_no + 1)]
  end

  defp process_row_rotate_lines([], _, _), do: []

  defp process_row_rotate_lines([line | lines], {row_no, count}, current_line_no) do
    new_line =
      case current_line_no == row_no do
        true -> rotate_string(line, count)
        false -> line
      end

    [new_line | process_row_rotate_lines(lines, {row_no, count}, current_line_no + 1)]
  end

  defp process_column_rotate_lines([], _, _), do: []

  defp process_column_rotate_lines([line | lines], [char | chars], column_no) do
    {new_start, <<_replaced::binary-size(1), new_end::binary>>} = String.split_at(line, column_no)
    new_line = new_start <> char <> new_end
    [new_line | process_column_rotate_lines(lines, chars, column_no)]
  end

  @doc """
  iex> Day08.blank_screen(3, 2)
  ["...", "..."]
  """
  def blank_screen(width, height) do
    "."
    |> String.duplicate(width)
    |> List.duplicate(height)
  end

  defp rotate_string(string, char_count) do
    # Take the last count characters from the end of the line, and move them to the start.
    char_count = -rem(char_count, String.length(string))
    {new_end, new_start} = String.split_at(string, char_count)
    new_start <> new_end
  end

  def part1_verify, do: parse_input() |> final_arrangement() |> lit_pixel_count()
  def part2_verify, do: parse_input() |> part2()
end
