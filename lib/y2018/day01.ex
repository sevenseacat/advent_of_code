defmodule Y2018.Day01 do
  use Advent.Day, no: 1

  @doc """
  iex> Day01.part1(["+1", "+1", "+1"])
  3

  iex> Day01.part1(["+1", "+1", "-2"])
  0

  iex> Day01.part1(["-1", "-2", "-3"])
  -6
  """
  def part1(list), do: do_part1(list, 0)

  def do_part1([], result), do: result

  def do_part1([<<sign::binary-1, val::binary>> | rest], result) do
    new_result = apply(Kernel, String.to_atom(sign), [result, String.to_integer(val)])
    do_part1(rest, new_result)
  end

  def parse_input(data) do
    data
    |> String.split()
  end

  def part1_verify, do: input() |> parse_input() |> part1()
end
