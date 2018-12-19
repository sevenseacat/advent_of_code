defmodule Y2018.Day16 do
  use Advent.Day, no: 16

  import Bitwise

  @commands ~w/addr addi mulr muli banr bani borr bori setr seti gtir gtri gtrr eqir eqri eqrr/a

  @doc """
  """
  def part1(input) do
    input
    |> parse_input()
    |> Enum.map(&possible_commands/1)
    |> Enum.filter(fn {_num, cmds} -> length(cmds) >= 3 end)
    |> length
  end

  @doc """
  iex> Day16.possible_commands(%{before: [3,2,1,1], after: [3,2,2,1], code: [9,2,1,2]})
  {9, [:addi, :mulr, :seti]}
  """
  def possible_commands(%{before: b, after: a, code: [num, in1, in2, out]}) do
    possibles =
      Enum.filter(@commands, fn option ->
        a == List.replace_at(b, out, apply(__MODULE__, option, [b, [in1, in2]]))
      end)

    {num, possibles}
  end

  def addr(rs, [a, b]), do: v(rs, a) + v(rs, b)
  def addi(rs, [a, b]), do: v(rs, a) + b
  def mulr(rs, [a, b]), do: v(rs, a) * v(rs, b)
  def muli(rs, [a, b]), do: v(rs, a) * b
  def banr(rs, [a, b]), do: band(v(rs, a), v(rs, b))
  def bani(rs, [a, b]), do: band(v(rs, a), b)
  def borr(rs, [a, b]), do: bor(v(rs, a), v(rs, b))
  def bori(rs, [a, b]), do: bor(v(rs, a), b)
  def setr(rs, [a, _]), do: v(rs, a)
  def seti(_, [a, _]), do: a
  def gtir(rs, [a, b]), do: bool(a > v(rs, b))
  def gtri(rs, [a, b]), do: bool(v(rs, a) > b)
  def gtrr(rs, [a, b]), do: bool(v(rs, a) > v(rs, b))
  def eqir(rs, [a, b]), do: bool(a == v(rs, b))
  def eqri(rs, [a, b]), do: bool(v(rs, a) == b)
  def eqrr(rs, [a, b]), do: bool(v(rs, a) == v(rs, b))

  defp v(rs, a), do: Enum.at(rs, a)

  defp bool(val) do
    if val, do: 1, else: 0
  end

  @doc """
  iex> Day16.parse_input("Before: [3, 2, 1, 1]\\n9 2 1 2\\nAfter:  [3, 2, 2, 1]")
  [%{before: [3,2,1,1], after: [3,2,2,1], code: [9,2,1,2]}]
  """
  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.chunk_every(3)
    |> Enum.map(&parse_record/1)
  end

  defp parse_record([before, code, after_]) do
    [_, b1, b2, b3, b4 | _] = String.split(before, ["Before: [", ", ", "]"])
    [_, a1, a2, a3, a4 | _] = String.split(after_, ["After:  [", ", ", "]"])
    code = String.split(code, [" "])

    %{
      before: [b1, b2, b3, b4] |> Enum.map(&String.to_integer/1),
      after: [a1, a2, a3, a4] |> Enum.map(&String.to_integer/1),
      code: code |> Enum.map(&String.to_integer/1)
    }
  end

  def part1_verify, do: input("day16_part1") |> part1()
end
