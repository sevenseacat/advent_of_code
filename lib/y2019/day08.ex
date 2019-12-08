defmodule Y2019.Day08 do
  use Advent.Day, no: 8

  @width 25
  @height 6

  @doc """
  iex> Day08.part1(["1","2","3","4","5","6","7","8","9","0","1","2"], 3, 2)
  1
  """
  def part1(input, width \\ @width, height \\ @height) do
    layer_size = width * height

    layer =
      input
      |> Enum.chunk_every(layer_size)
      |> Enum.map(&frequencies/1)
      |> Enum.min_by(fn map -> Map.get(map, "0") end)

    Map.get(layer, "1") * Map.get(layer, "2")
  end

  def parse_input(data) do
    data
    |> String.trim()
    |> String.codepoints()
  end

  # https://www.rosettacode.org/wiki/Letter_frequency#Elixir
  def frequencies(str) do
    Enum.reduce(str, Map.new(), fn c, acc -> Map.update(acc, c, 1, &(&1 + 1)) end)
  end

  def part1_verify, do: input() |> parse_input() |> part1()
end
