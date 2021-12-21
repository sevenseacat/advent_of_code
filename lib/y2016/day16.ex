defmodule Y2016.Day16 do
  use Advent.Day, no: 16

  @puzzle_input "10010000000110000"

  @doc """
  iex> Day16.part1("10000", 20)
  "01100"
  """
  def part1(initial, min_length) do
    initial
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
    |> grow_until(min_length)
    |> Enum.take(min_length)
    |> checksum()
    |> Enum.join("")
  end

  def grow_until(input, min_length) when length(input) >= min_length, do: input

  def grow_until(input, min_length) do
    input
    |> grow()
    |> grow_until(min_length)
  end

  @doc """
  iex> Day16.grow([1])
  [1,0,0]

  iex> Day16.grow([1,1,1,1,0,0,0,0,1,0,1,0])
  [1,1,1,1,0,0,0,0,1,0,1,0,0,1,0,1,0,1,1,1,1,0,0,0,0]
  """
  def grow(input) do
    input ++
      [
        0
        | Enum.reduce(input, [], fn
            1, acc -> [0 | acc]
            0, acc -> [1 | acc]
          end)
      ]
  end

  @doc """
  iex> Day16.checksum([1,1,0,0,1,0,1,1,0,1,0,0])
  [1,0,0]
  """
  def checksum(input) do
    sum = chunk_it(input, [])
    if rem(length(sum), 2) != 0, do: sum, else: checksum(sum)
  end

  defp chunk_it([], acc), do: Enum.reverse(acc)
  defp chunk_it([x, x | rest], acc), do: chunk_it(rest, [1 | acc])
  defp chunk_it([_, _ | rest], acc), do: chunk_it(rest, [0 | acc])

  def part1_verify, do: part1(@puzzle_input, 272)
  def part2_verify, do: part1(@puzzle_input, 35_651_584)
end
