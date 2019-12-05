defmodule Y2019.Day05 do
  use Advent.Day, no: 5

  def part1(program, input) do
    run_program(program, input)
    |> elem(1)
  end

  @doc """
  iex> Day05.run_program(:array.from_list [1,0,0,0,99])
  {[2,0,0,0,99], []}

  iex> Day05.run_program(:array.from_list [2,3,0,3,99])
  {[2,3,0,6,99], []}

  iex> Day05.run_program(:array.from_list [2,4,4,5,99,0])
  {[2,4,4,5,99,9801], []}

  iex> Day05.run_program(:array.from_list [1,1,1,4,99,5,6,0,99])
  {[30,1,1,4,2,5,6,0,99], []}

  iex> Day05.run_program(:array.from_list([3,0,4,0,99]), 444)
  {[444,0,4,0,99], [444]}

  iex> Day05.run_program(:array.from_list [1002,4,3,4,33])
  {[1002,4,3,4,99], []}
  """
  def run_program(array, input \\ nil, pos \\ 0, outputs \\ []) do
    raw_opcode = :array.get(pos, array)

    modes =
      div(raw_opcode, 100)
      |> Integer.to_string()
      |> String.reverse()

    opcode = rem(raw_opcode, 100)

    case opcode do
      1 ->
        calc(array, pos, &Kernel.+/2, modes) |> run_program(input, pos + 4, outputs)

      2 ->
        calc(array, pos, &Kernel.*/2, modes) |> run_program(input, pos + 4, outputs)

      3 ->
        assign(array, pos, input) |> run_program(input, pos + 2, outputs)

      4 ->
        {array, outputs} = output(array, pos, modes, outputs)
        run_program(array, input, pos + 2, outputs)

      99 ->
        {:array.to_list(array), Enum.reverse(outputs)}

      val ->
        {:error, "'#{val}' at position #{pos} does not match a valid opcode"}
    end
  end

  defp calc(array, pos, op, modes) do
    op1 = calc_with_mode(array, pos, 1, modes)
    op2 = calc_with_mode(array, pos, 2, modes)

    :array.set(:array.get(pos + 3, array), op.(op1, op2), array)
  end

  defp calc_with_mode(array, pos, offset, modes) do
    case String.at(modes, offset - 1) do
      "1" ->
        :array.get(pos + offset, array)

      # Might be 0 or a trailing nil
      _ ->
        :array.get(:array.get(pos + offset, array), array)
    end
  end

  def assign(array, pos, val) do
    :array.set(:array.get(pos + 1, array), val, array)
  end

  def output(array, pos, modes, outputs) do
    {array, [calc_with_mode(array, pos, 1, modes) | outputs]}
  end

  def parse_input(data) do
    data
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> :array.from_list()
  end

  def part1_verify, do: input() |> parse_input() |> part1(1) |> List.last()
end
