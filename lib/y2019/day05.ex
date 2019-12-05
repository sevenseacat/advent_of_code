defmodule Y2019.Day05 do
  use Advent.Day, no: 5

  def part1(program, input) do
    run_program(program, input)
  end

  @doc """
  iex> Day05.run_program(:array.from_list [1,0,0,0,99]) |> :array.to_list
  [2,0,0,0,99]

  iex> Day05.run_program(:array.from_list [2,3,0,3,99]) |> :array.to_list
  [2,3,0,6,99]

  iex> Day05.run_program(:array.from_list [2,4,4,5,99,0]) |> :array.to_list
  [2,4,4,5,99,9801]

  iex> Day05.run_program(:array.from_list [1,1,1,4,99,5,6,0,99]) |> :array.to_list
  [30,1,1,4,2,5,6,0,99]

  iex> Day05.run_program(:array.from_list([3,0,4,0,99]), 4444)
  4444
  """
  def run_program(array, input \\ nil, pos \\ 0) do
    case :array.get(pos, array) do
      1 -> calc(array, pos, &Kernel.+/2) |> run_program(input, pos + 4)
      2 -> calc(array, pos, &Kernel.*/2) |> run_program(input, pos + 4)
      3 -> assign(array, pos, input) |> run_program(input, pos + 2)
      4 -> output(array, pos)
      99 -> array
      val -> {:error, "#{val} at position #{pos}"}
    end
  end

  defp calc(array, pos, op) do
    op1 = :array.get(:array.get(pos + 1, array), array)
    op2 = :array.get(:array.get(pos + 2, array), array)

    :array.set(:array.get(pos + 3, array), op.(op1, op2), array)
  end

  def assign(array, pos, val) do
    :array.set(:array.get(pos + 1, array), val, array)
  end

  def output(array, pos) do
    :array.get(:array.get(pos + 1, array), array)
  end

  def parse_input(data) do
    data
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> :array.from_list()
  end

  def part1_verify, do: input() |> parse_input() |> part1(nil)
end
