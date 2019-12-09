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

  def run_program(array, input \\ [], pos \\ 0, outputs \\ [], base \\ 0) do
    raw_opcode = :array.get(pos, array)

    modes = div(raw_opcode, 100) |> Integer.to_string() |> String.reverse()
    opcode = rem(raw_opcode, 100)

    case opcode do
      1 ->
        calc(&Kernel.+/2, array, pos, modes, base) |> run_program(input, pos + 4, outputs, base)

      2 ->
        calc(&Kernel.*/2, array, pos, modes, base) |> run_program(input, pos + 4, outputs, base)

      3 ->
        case input do
          [h | t] ->
            assign(array, pos, h, modes, base) |> run_program(t, pos + 2, outputs, base)

          [] ->
            # Wait for more inputs. Stop running for now. (Day 7)
            {:pause, {array, Enum.reverse(outputs), pos}}
        end

      4 ->
        {array, outputs} = output(array, pos, modes, outputs, base)
        run_program(array, input, pos + 2, outputs, base)

      5 ->
        new_pos = jump_if(&Kernel.!=/2, array, pos, modes, base)
        run_program(array, input, new_pos, outputs, base)

      6 ->
        new_pos = jump_if(&Kernel.==/2, array, pos, modes, base)
        run_program(array, input, new_pos, outputs, base)

      7 ->
        comparison(&Kernel.</2, array, pos, modes, base)
        |> run_program(input, pos + 4, outputs, base)

      8 ->
        comparison(&Kernel.==/2, array, pos, modes, base)
        |> run_program(input, pos + 4, outputs, base)

      9 ->
        run_program(
          array,
          input,
          pos + 2,
          outputs,
          base + calc_with_mode(array, pos, 1, modes, base)
        )

      99 ->
        {:halt, {:array.to_list(array), Enum.reverse(outputs)}}

      val ->
        {:error, "'#{val}' at position #{pos} does not match a valid opcode"}
    end
  end

  def jump_if(op, array, pos, modes, base) do
    if op.(calc_with_mode(array, pos, 1, modes, base), 0) do
      calc_with_mode(array, pos, 2, modes, base)
    else
      pos + 3
    end
  end

  def comparison(op, array, pos, modes, base) do
    op1 = calc_with_mode(array, pos, 1, modes, base)
    op2 = calc_with_mode(array, pos, 2, modes, base)

    new_val = if op.(op1, op2), do: 1, else: 0

    :array.set(write_pos(array, pos, 3, modes, base), new_val, array)
  end

  defp calc(op, array, pos, modes, base) do
    op1 = calc_with_mode(array, pos, 1, modes, base)
    op2 = calc_with_mode(array, pos, 2, modes, base)

    :array.set(write_pos(array, pos, 3, modes, base), op.(op1, op2), array)
  end

  defp calc_with_mode(array, pos, offset, modes, base) do
    case String.at(modes, offset - 1) do
      "1" ->
        :array.get(pos + offset, array)

      "2" ->
        :array.get(:array.get(pos + offset, array) + base, array)

      # Might be 0 or a trailing nil
      _ ->
        :array.get(:array.get(pos + offset, array), array)
    end
  end

  def assign(array, pos, val, modes, base) do
    :array.set(write_pos(array, pos, 1, modes, base), val, array)
  end

  def write_pos(array, pos, offset, modes, base) do
    case String.at(modes, offset - 1) do
      "2" ->
        :array.get(pos + offset, array) + base

      _ ->
        :array.get(pos + offset, array)
    end
  end

  def output(array, pos, modes, outputs, base) do
    {array, [calc_with_mode(array, pos, 1, modes, base) | outputs]}
  end

  def parse_input(data) do
    data
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> :array.from_list(0)
  end

  def part1_verify, do: input() |> parse_input() |> part1(1) |> List.last()
  def part2_verify, do: input() |> parse_input() |> part2(5) |> List.last()
end
