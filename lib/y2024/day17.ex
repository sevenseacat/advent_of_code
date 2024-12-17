defmodule Y2024.Day17 do
  use Advent.Day, no: 17

  @doc """
  # If register C contains 9, the program 2,6 would set register B to 1.
  iex> Day17.part1(%{registers: {1, 2, 9}, program: [2, 6]}) |> elem(0)
  {1, 1, 9}

  If register A contains 10, the program 5,0,5,1,5,4 would output 0,1,2.
  iex> Day17.part1(%{registers: {10, 7, 13}, program: [5,0,5,1,5,4]}) |> elem(1)
  "0,1,2"

  If register A contains 2024, the program 0,1,5,4,3,0 would output 4,2,5,6,7,7,7,7,3,1,0 and leave 0 in register A.
  iex> Day17.part1(%{registers: {2024, 2, 4}, program: [0,1,5,4,3,0]})
  {{0, 2, 4}, "4,2,5,6,7,7,7,7,3,1,0"}

  If register B contains 29, the program 1,7 would set register B to 26.
  iex> Day17.part1(%{registers: {6, 29, 12}, program: [1,7]}) |> elem(0)
  {6, 26, 12}

  If register B contains 2024 and register C contains 43690, the program 4,0 would set register B to 44354.
  iex> Day17.part1(%{registers: {35, 2024, 43690}, program: [4,0]}) |> elem(0)
  {35, 44354, 43690}

  iex> Day17.part1(%{registers: {729, 0, 0}, program: [0,1,5,4,3,0]}) |> elem(1)
  "4,6,3,5,6,3,5,2,1,0"
  """
  def part1(%{registers: registers, program: program}) do
    index = 0

    program =
      program
      |> Enum.chunk_every(2)
      |> Enum.with_index()
      |> Map.new(fn {p, i} -> {i, p} end)

    {registers, output} = run(registers, program, index, map_size(program) - 1, [])
    {registers, Enum.join(output, ",")}
  end

  # @doc """
  # iex> Day17.part2("update or delete me")
  # "update or delete me"
  # """
  # def part2(input) do
  #   input
  # end

  defp run(registers, _program, index, max, output) when index > max,
    do: {registers, Enum.reverse(output)}

  defp run(registers, program, index, max, output) do
    {registers, index, output} = op(Map.fetch!(program, index), registers, index, output)
    run(registers, program, index, max, output)
  end

  defp op([0, operand], {a, b, c} = rs, index, output) do
    result = div(a, Integer.pow(2, operand(operand, rs)))
    {{result, b, c}, index + 1, output}
  end

  defp op([1, operand], {a, b, c}, index, output) do
    result = Bitwise.bxor(b, operand)
    {{a, result, c}, index + 1, output}
  end

  defp op([2, operand], {a, _b, c} = rs, index, output) do
    result = rem(operand(operand, rs), 8)
    {{a, result, c}, index + 1, output}
  end

  defp op([3, operand], {a, _, _} = rs, index, output) do
    if a == 0 do
      {rs, index + 1, output}
    else
      {rs, div(operand, 2), output}
    end
  end

  defp op([4, _operand], {a, b, c}, index, output) do
    result = Bitwise.bxor(b, c)
    {{a, result, c}, index + 1, output}
  end

  defp op([5, operand], rs, index, output) do
    result = rem(operand(operand, rs), 8)
    {rs, index + 1, [result | output]}
  end

  defp op([6, operand], {a, _, c} = rs, index, output) do
    result = div(a, Integer.pow(2, operand(operand, rs)))
    {{a, result, c}, index + 1, output}
  end

  defp op([7, operand], {a, b, _c} = rs, index, output) do
    result = div(a, Integer.pow(2, operand(operand, rs)))
    {{a, b, result}, index + 1, output}
  end

  defp operand(operand, {a, b, c}) do
    case operand do
      x when x in 0..3 -> x
      4 -> a
      5 -> b
      6 -> c
      7 -> raise RuntimeError, "not used"
    end
  end

  @doc """
  iex> Day17.parse_input("Register A: 729\\nRegister B: 0\\nRegister C: 0\\n\\nProgram: 0,1,5,4,3,0\\n")
  %{registers: {729, 0, 0}, program: [0,1,5,4,3,0]}
  """
  def parse_input(input) do
    [a, b, c, program] = String.split(input, "\n", trim: true)

    %{
      registers: {parse_register(a), parse_register(b), parse_register(c)},
      program: parse_program(program)
    }
  end

  defp parse_register(string) do
    [_, num] = String.split(string, ": ", trim: true)
    String.to_integer(num)
  end

  defp parse_program(string) do
    string
    |> String.replace("Program: ", "")
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def part1_verify, do: input() |> parse_input() |> part1() |> elem(1)
  # def part2_verify, do: input() |> parse_input() |> part2()
end
