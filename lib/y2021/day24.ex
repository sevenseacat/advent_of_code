defmodule Y2021.Day24 do
  use Advent.Day, no: 24

  @doc """
  iex> Day24.part1(:parsed_input)
  :ok
  """
  def part1(cmds) do
    check_cmds(cmds, 99_999_999_999_999, %{"w" => 0, "x" => 0, "y" => 0, "z" => 0})
  end

  defp check_cmds(cmds, num_to_check, registers) do
    digits = Integer.digits(num_to_check)

    # No zeros allowed in the model number.
    if Enum.any?(digits, fn digit -> digit == 0 end) do
      check_cmds(cmds, num_to_check - 1, registers)
    else
      # Run the commands, get the result.
      registers = run_cmds(cmds, digits, registers)

      if Map.get(registers, "z") == 0 do
        num_to_check
      else
        check_cmds(cmds, num_to_check - 1, registers)
      end
    end
  end

  defp run_cmds([], _digits, registers), do: registers

  defp run_cmds([{:inp, reg} | cmds], [digit | digits], registers) do
    run_cmds(cmds, digits, Map.put(registers, reg, digit))
  end

  defp run_cmds([{:add, reg, val} | cmds], digits, registers) do
    run_cmds(cmds, digits, Map.update!(registers, reg, &(&1 + val(registers, val))))
  end

  defp run_cmds([{:mul, reg, val} | cmds], digits, registers) do
    run_cmds(cmds, digits, Map.update!(registers, reg, &(&1 * val(registers, val))))
  end

  defp run_cmds([{:div, reg, val} | cmds], digits, registers) do
    run_cmds(cmds, digits, Map.update!(registers, reg, &div(&1, val(registers, val))))
  end

  defp run_cmds([{:mod, reg, val} | cmds], digits, registers) do
    run_cmds(cmds, digits, Map.update!(registers, reg, &rem(&1, val(registers, val))))
  end

  defp run_cmds([{:eql, reg, val} | cmds], digits, registers) do
    run_cmds(
      cmds,
      digits,
      Map.update!(registers, reg, &if(&1 == val(registers, val), do: 1, else: 0))
    )
  end

  defp val(_registers, val) when is_integer(val), do: val
  defp val(registers, val), do: Map.fetch!(registers, val)

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
end
