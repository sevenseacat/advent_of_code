defmodule Y2015.Day08 do
  use Advent.Day, no: 8

  def part1(filename) do
    filename
    |> parse_input
    |> Enum.map(&raw_length/1)
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

  def part1_verify, do: part1("lib/y2015/input/day08.txt")
end
