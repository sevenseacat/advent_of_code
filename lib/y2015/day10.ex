defmodule Y2015.Day10 do
  use Advent.Day, no: 10

  @input 1_113_222_113

  @doc """
  iex> Day10.part1(1, 1)
  {11, 2}

  iex> Day10.part1(1, 2)
  {21, 2}

  iex> Day10.part1(1, 3)
  {1211, 4}

  iex> Day10.part1(1, 4)
  {111221, 6}

  iex> Day10.part1(1, 5)
  {312211, 6}
  """
  def part1(input, times) do
    input
    |> Integer.to_string()
    |> String.graphemes()
    |> look_and_say(times)
  end

  def look_and_say(input, 0) do
    {input |> List.to_string() |> String.to_integer(), length(input)}
  end

  def look_and_say(input, times) do
    input
    |> Enum.chunk_by(fn x -> x end)
    |> Enum.reduce([], fn list, acc -> [hd(list), "#{length(list)}" | acc] end)
    |> Enum.reverse()
    |> look_and_say(times - 1)
  end

  def part1_verify, do: part1(@input, 40) |> elem(1)
  def part2_verify, do: part1(@input, 50) |> elem(1)
end
