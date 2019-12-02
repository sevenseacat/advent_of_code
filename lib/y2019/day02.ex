defmodule Y2019.Day02 do
  use Advent.Day, no: 2

  def part1(input) do
    result =
      input
      |> seed_program(12, 2)
      |> run_program

    :array.get(0, result)
  end

  def part2(input) do
    # I think this can be done more simply with comprehensions, I just don't know how.
    opts = for noun <- 0..99, verb <- 0..99, do: {noun, verb}

    {noun, verb} =
      Enum.find(opts, fn {noun, verb} ->
        result =
          input
          |> seed_program(noun, verb)
          |> run_program

        :array.get(0, result) == 19_690_720
      end)

    100 * noun + verb
  end

  defp seed_program(array, noun, verb) do
    :array.set(1, noun, :array.set(2, verb, array))
  end

  @doc """
  iex> Day02.run_program(:array.from_list [1,0,0,0,99]) |> :array.to_list
  [2,0,0,0,99]

  iex> Day02.run_program(:array.from_list [2,3,0,3,99]) |> :array.to_list
  [2,3,0,6,99]

  iex> Day02.run_program(:array.from_list [2,4,4,5,99,0]) |> :array.to_list
  [2,4,4,5,99,9801]

  iex> Day02.run_program(:array.from_list [1,1,1,4,99,5,6,0,99]) |> :array.to_list
  [30,1,1,4,2,5,6,0,99]
  """
  def run_program(array, pos \\ 0) do
    case :array.get(pos, array) do
      1 -> do_stuff(array, pos, &Kernel.+/2) |> run_program(pos + 4)
      2 -> do_stuff(array, pos, &Kernel.*/2) |> run_program(pos + 4)
      99 -> array
      _ -> :error
    end
  end

  defp do_stuff(array, pos, op) do
    op1 = :array.get(:array.get(pos + 1, array), array)
    op2 = :array.get(:array.get(pos + 2, array), array)

    :array.set(:array.get(pos + 3, array), op.(op1, op2), array)
  end

  def parse_input(data) do
    data
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> :array.from_list()
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  def part2_verify, do: input() |> parse_input() |> part2()
end
