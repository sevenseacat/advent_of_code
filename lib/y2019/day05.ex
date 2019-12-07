defmodule Y2019.Day05 do
  use Advent.Day, no: 5

  def part1(program, input) do
    {:halt, {_program, outputs}} = run_program(program, List.wrap(input))
    outputs
  end

  def part2(program, input) do
    {:halt, {_program, outputs}} = run_program(program, List.wrap(input))
    outputs
  end

  def run_program(array, input \\ [], pos \\ 0, outputs \\ []) do
    raw_opcode = :array.get(pos, array)

    modes =
      div(raw_opcode, 100)
      |> Integer.to_string()
      |> String.reverse()

    opcode = rem(raw_opcode, 100)

    case opcode do
      1 ->
        calc(&Kernel.+/2, array, pos, modes) |> run_program(input, pos + 4, outputs)

      2 ->
        calc(&Kernel.*/2, array, pos, modes) |> run_program(input, pos + 4, outputs)

      3 ->
        case input do
          [h | t] ->
            assign(array, pos, h) |> run_program(t, pos + 2, outputs)

          [] ->
            # Wait for more inputs. Stop running for now. (Day 7)
            {:pause, {array, Enum.reverse(outputs), pos}}
        end

      4 ->
        {array, outputs} = output(array, pos, modes, outputs)
        run_program(array, input, pos + 2, outputs)

      5 ->
        new_pos = jump_if(&Kernel.!=/2, array, pos, modes)
        run_program(array, input, new_pos, outputs)

      6 ->
        new_pos = jump_if(&Kernel.==/2, array, pos, modes)
        run_program(array, input, new_pos, outputs)

      7 ->
        comparison(&Kernel.</2, array, pos, modes) |> run_program(input, pos + 4, outputs)

      8 ->
        comparison(&Kernel.==/2, array, pos, modes) |> run_program(input, pos + 4, outputs)

      99 ->
        {:halt, {:array.to_list(array), Enum.reverse(outputs)}}

      val ->
        {:error, "'#{val}' at position #{pos} does not match a valid opcode"}
    end
  end

  def jump_if(op, array, pos, modes) do
    if op.(calc_with_mode(array, pos, 1, modes), 0) do
      calc_with_mode(array, pos, 2, modes)
    else
      pos + 3
    end
  end

  def comparison(op, array, pos, modes) do
    op1 = calc_with_mode(array, pos, 1, modes)
    op2 = calc_with_mode(array, pos, 2, modes)

    new_val = if op.(op1, op2), do: 1, else: 0

    :array.set(:array.get(pos + 3, array), new_val, array)
  end

  defp calc(op, array, pos, modes) do
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
  def part2_verify, do: input() |> parse_input() |> part2(5) |> List.last()
end
