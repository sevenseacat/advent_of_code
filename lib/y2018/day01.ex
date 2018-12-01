defmodule Y2018.Day01 do
  use Advent.Day, no: 1

  @doc """
  iex> Day01.part1("+1\\n+1\\n+1")
  3

  iex> Day01.part1("+1\\n+1\\n-2")
  0

  iex> Day01.part1("-1\\n-2\\n-3")
  -6
  """
  def part1(data) do
    data
    |> String.split()
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
  end

  @doc """
  iex> Day01.part2("+1\\n-1")
  0

  iex> Day01.part2("+3\\n+3\\n+4\\n-2\\n-4")
  10

  iex> Day01.part2("-6\\n+3\\n+8\\n+5\\n-6")
  5

  iex> Day01.part2("+7\\n+7\\n-2\\n-7\\n-4")
  14
  """
  def part2(data) do
    list = String.split(data)
    do_part2(list, 0, list, [])
  end

  def do_part2([], current, original, seen), do: do_part2(original, current, original, seen)

  def do_part2([<<sign::binary-1, val::binary>> | rest], current, original, seen) do
    if current in seen do
      current
    else
      new = apply(Kernel, String.to_atom(sign), [current, String.to_integer(val)])
      do_part2(rest, new, original, [current | seen])
    end
  end

  def part1_verify, do: input() |> part1()
  def part2_verify, do: input() |> part2()
end
