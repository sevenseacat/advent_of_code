defmodule Y2017.Day01 do
  use Advent.Day, no: 01

  @doc """
  iex> Day01.part1("1122")
  3

  iex> Day01.part1("1111")
  4

  iex> Day01.part1("1234")
  0

  iex> Day01.part1("91212129")
  9
  """
  def part1(input) do
    list = String.codepoints(input)
    do_part1(list, list, 0)
  end

  defp do_part1([a, a | rest], input, total) do
    do_part1([a | rest], input, total + String.to_integer(a))
  end

  defp do_part1([_, b | rest], input, total) do
    do_part1([b | rest], input, total)
  end

  defp do_part1([a], [a | _rest], total), do: total + String.to_integer(a)

  defp do_part1(_, _, total), do: total

  @doc """
  iex> Day01.part2("1212")
  6

  iex> Day01.part2("1221")
  0

  iex> Day01.part2("123425")
  4

  iex> Day01.part2("123123")
  12
  """
  def part2(input) do
    list = String.codepoints(input)
    {list1, list2} = Enum.split(list, div(length(list), 2))
    do_part2(list1, list2, 0) + do_part2(list2, list1, 0)
  end

  defp do_part2([a | as], [a | bs], total), do: do_part2(as, bs, total + String.to_integer(a))
  defp do_part2([_ | as], [_ | bs], total), do: do_part2(as, bs, total)
  defp do_part2([], [], total), do: total

  def part1_verify, do: input() |> part1()
  def part2_verify, do: input() |> part2()
end
