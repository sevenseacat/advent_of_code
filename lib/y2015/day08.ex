defmodule Y2015.Day08 do
  use Advent.Day, no: 8

  def part1(filename) do
    filename
    |> parse_input
    |> Enum.map(&raw_length/1)
    |> Enum.sum()
  end

  def part2(filename) do
    filename
    |> parse_input
    |> Enum.map(&cooked_length/1)
    |> Enum.sum()
  end

  def parse_input(filename) do
    Stream.resource(
      fn -> File.open!(filename, [:binary]) end,
      fn file -> parse_line(file) end,
      fn file -> File.close(file) end
    )
  end

  defp parse_line(file) do
    case IO.binread(file, :line) do
      :eof -> {:halt, file}
      line -> {[String.trim(line)], file}
    end
  end

  def raw_length(raw) do
    {cooked, _} = Code.eval_string(raw)
    String.length(raw) - String.length(cooked)
  end

  def cooked_length(raw) do
    cooked =
      raw
      |> String.replace("\\", "\\\\")
      |> String.replace("\"", "\\\"")

    # 2 - extra quotes needed after the old ones were escaped
    String.length(cooked) - String.length(raw) + 2
  end

  def part1_verify, do: part1("lib/y2015/input/day08.txt")
  def part2_verify, do: part2("lib/y2015/input/day08.txt")
end
