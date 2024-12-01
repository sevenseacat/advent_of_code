defmodule Y2021.Day24 do
  @moduledoc """
  So I reverse-engineered another problem and it *still* takes a long time!?!?!

  * The input file can be broken into chunks, each one starting with `inp w`. These represent the
    digits in the final number.
  * The only thing that matters after each chunk is the value in register `z`.
  * Each chunk simplified one of two formulas, depending on whether a positive or negative number is
    added to register `x`. (These formulas were calculated by manually working out what each chunk does.)
  * These are
    * `small_formula` (positive number greater than 10 is added, so z mod 26 + number can never equal 1..9) and
    * `big_formula` (negative number is added, so z mod 26 - number *might* equal 1..9. I've called this value `q`).
  """
  use Advent.Day, no: 24

  def part1, do: do_parts([{[], 0}], reverse_engineered_funcs(), 9..1//-1)
  def part2, do: do_parts([{[], 0}], reverse_engineered_funcs(), 1..9//1)

  defp do_parts(states, [cmd], range) do
    states
    |> Enum.find_value(fn {digits, z} ->
      # Digits are the first 13 digits of the number in reverse order
      case Enum.find(range, fn w -> cmd.(w, z) == 0 end) do
        nil -> nil
        num -> [num | digits]
      end
    end)
    |> Enum.reverse()
    |> Enum.join()
  end

  defp do_parts(states, [cmd | cmds], range) do
    for(
      {digits, state} <- states,
      digit <- range,
      do: {[digit | digits], cmd.(digit, state)}
    )
    |> Enum.uniq_by(fn {_digits, state} -> state end)
    |> do_parts(cmds, range)
  end

  defp reverse_engineered_funcs do
    [
      fn w, _ -> w + 10 end,
      fn w, z -> small_formula(w, z, 5) end,
      fn w, z -> small_formula(w, z, 12) end,
      fn w, z -> big_formula(w, z, -12, 12) end,
      fn w, z -> small_formula(w, z, 6) end,
      fn w, z -> big_formula(w, z, -2, 4) end,
      fn w, z -> small_formula(w, z, 15) end,
      fn w, z -> big_formula(w, z, -12, 3) end,
      fn w, z -> small_formula(w, z, 7) end,
      fn w, z -> small_formula(w, z, 11) end,
      fn w, z -> big_formula(w, z, -3, 2) end,
      fn w, z -> big_formula(w, z, -13, 12) end,
      fn w, z -> big_formula(w, z, -12, 4) end,
      fn w, z -> big_formula(w, z, -13, 11) end
    ]
  end

  defp small_formula(w, z, add), do: z * 26 + w + add

  defp big_formula(w, z, neg, two) do
    q = q(w, z, neg)
    div(z, 26) * (25 * q + 1) + q * (w + two)
  end

  defp q(w, z, neg) do
    if rem(z, 26) + neg == w, do: 0, else: 1
  end

  def part1_verify, do: part1()
  def part2_verify, do: part2()
end
