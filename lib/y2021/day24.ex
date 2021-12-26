defmodule Y2021.Day24 do
  use Advent.Day, no: 24

  def part1(cmds) do
    cmds = group_per_input_cmd(cmds)
    do_parts(cmds, [{[], {0, 0}}], 9..1)
  end

  def part2(cmds) do
    cmds = group_per_input_cmd(cmds)
    do_parts(cmds, [{[], {0, 0}}], 1..9)
  end

  defp do_parts([], outputs, _range) do
    outputs
    |> Enum.find(fn {_digits, {_, z}} -> z == 0 end)
    |> elem(0)
    |> Enum.reverse()
    |> Enum.join()
  end

  defp do_parts([cmd_set | cmd_sets], states, digit_range) do
    new_states =
      for(
        {digits, {y, z}} <- states,
        digit <- digit_range,
        do: {[digit | digits], run_cmds(cmd_set, [digit], {0, 0, y, z})}
      )
      |> Enum.uniq_by(fn {_digits, registers} -> registers end)

    IO.puts("Digit #{hd(new_states) |> elem(0) |> length}: #{length(new_states)} states")
    do_parts(cmd_sets, new_states, digit_range)
  end

  # The w register will be overwritten at the start of each new block of cmds
  defp run_cmds([], _digits, {_, _, y, z}), do: {y, z}

  defp run_cmds([{:inp, reg} | cmds], [digit | digits], registers) do
    run_cmds(cmds, digits, set_val(registers, reg, digit))
  end

  defp run_cmds([{:add, reg, val} | cmds], digits, registers) do
    run_cmds(
      cmds,
      digits,
      update_val(registers, reg, &(&1 + val(registers, val)))
    )
  end

  defp run_cmds([{:mul, reg, val} | cmds], digits, registers) do
    run_cmds(cmds, digits, update_val(registers, reg, &(&1 * val(registers, val))))
  end

  defp run_cmds([{:div, reg, val} | cmds], digits, registers) do
    run_cmds(cmds, digits, update_val(registers, reg, &div(&1, val(registers, val))))
  end

  defp run_cmds([{:mod, reg, val} | cmds], digits, registers) do
    run_cmds(cmds, digits, update_val(registers, reg, &rem(&1, val(registers, val))))
  end

  defp run_cmds([{:eql, reg, val} | cmds], digits, registers) do
    run_cmds(
      cmds,
      digits,
      update_val(registers, reg, &if(&1 == val(registers, val), do: 1, else: 0))
    )
  end

  defp set_val({_w, x, y, z}, "w", val), do: {val, x, y, z}
  defp set_val({w, _x, y, z}, "x", val), do: {w, val, y, z}
  defp set_val({w, x, _y, z}, "y", val), do: {w, x, val, z}
  defp set_val({w, x, y, _z}, "z", val), do: {w, x, y, val}

  defp val(_registers, val) when is_integer(val), do: val
  defp val({w, _, _, _}, "w"), do: w
  defp val({_, x, _, _}, "x"), do: x
  defp val({_, _, y, _}, "y"), do: y
  defp val({_, _, _, z}, "z"), do: z

  defp update_val(registers, reg, update_fn) do
    set_val(registers, reg, update_fn.(val(registers, reg)))
  end

  # Split the commands up into groups headed by a new input. Each group will be run
  # in a branching BFS manner for all possible digits, to avoid duplication of work.
  defp group_per_input_cmd(cmds) do
    Enum.chunk_while(
      cmds,
      [],
      fn cmd, acc ->
        if elem(cmd, 0) == :inp do
          {:cont, Enum.reverse(acc), [cmd]}
        else
          {:cont, [cmd | acc]}
        end
      end,
      fn
        [] -> {:cont, []}
        acc -> {:cont, Enum.reverse(acc), nil}
      end
    )
    |> tl()
  end

  @doc """
  iex> Day24.parse_input("inp x\\nmul x -1\\n")
  [{:inp, "x"}, {:mul, "x", -1}]
  """
  def parse_input(input) do
    for line <- String.split(input, "\n", trim: true) do
      parse_line(String.split(line, " "))
    end
  end

  defp parse_line(["inp", reg]), do: {:inp, reg}

  defp parse_line([op, reg, val]) when val in ["w", "x", "y", "z"] do
    {String.to_atom(op), reg, val}
  end

  defp parse_line([op, reg, val]) do
    {String.to_atom(op), reg, String.to_integer(val)}
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  def part2_verify, do: input() |> parse_input() |> part2()
end
