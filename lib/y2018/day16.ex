defmodule Y2018.Day16 do
  use Advent.Day, no: 16

  import Bitwise

  @commands ~w/addr addi mulr muli banr bani borr bori setr seti gtir gtri gtrr eqir eqri eqrr/a

  @doc """
  """
  def part1(input) do
    input
    |> parse_input_part1()
    |> Enum.map(&possible_commands/1)
    |> Enum.filter(fn {_num, cmds} -> MapSet.size(cmds) >= 3 end)
    |> length
  end

  def part2(input1, input2) do
    options =
      input1
      |> parse_input_part1()
      |> Enum.map(&possible_commands/1)
      |> Enum.group_by(fn {num, _} -> num end)
      |> Enum.map(fn {num, types} ->
        {num, Enum.map(types, fn {_, type} -> type end)}
      end)
      |> Enum.into(%{})

    mapping = filter_one_option(options, %{})

    input2
    |> parse_input_part2()
    |> run_codes({0, 0, 0, 0}, mapping)
  end

  defp filter_one_option(options, known) when map_size(options) == 0, do: known

  defp filter_one_option(options, known) do
    {confirmed_num, confirmed_type} = find_confirmed_option(options)

    filtered_options =
      options
      |> Enum.filter(fn {num, _} -> num != confirmed_num end)
      |> Enum.map(fn {num, opts} ->
        {num, Enum.map(opts, fn opt -> MapSet.delete(opt, confirmed_type) end)}
      end)
      |> Enum.into(%{})

    filter_one_option(filtered_options, Map.put(known, confirmed_num, confirmed_type))
  end

  # One of the unknown op codes numbers is going to have only one valid option,
  # one possibility that is unique to all of the examples.
  defp find_confirmed_option(options) do
    {num, types} =
      Enum.find(options, fn {_, [initial | opts]} ->
        common_opts =
          Enum.reduce(opts, initial, fn opt, acc ->
            MapSet.intersection(opt, acc)
          end)

        MapSet.size(common_opts) == 1
      end)

    {num, types |> hd |> MapSet.to_list() |> hd}
  end

  defp run_codes([], registers, _), do: registers

  defp run_codes([{op, in1, in2, out} | codes], registers, mapping) do
    run_codes(
      codes,
      put_elem(registers, out, apply(__MODULE__, Map.get(mapping, op), [registers, [in1, in2]])),
      mapping
    )
  end

  @doc """
  iex> Day16.possible_commands(%{before: {3,2,1,1}, after: {3,2,2,1}, code: {9,2,1,2}})
  {9, MapSet.new([:addi, :mulr, :seti])}
  """
  def possible_commands(%{before: b, after: a, code: {num, in1, in2, out}}) do
    possibles =
      Enum.filter(@commands, fn option ->
        a == put_elem(b, out, apply(__MODULE__, option, [b, [in1, in2]]))
      end)

    {num, MapSet.new(possibles)}
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

  defp v(rs, a), do: elem(rs, a)

  defp bool(val) do
    if val, do: 1, else: 0
  end

  @doc """
  iex> Day16.parse_input_part1("Before: [3, 2, 1, 1]\\n9 2 1 2\\nAfter:  [3, 2, 2, 1]")
  [%{before: {3,2,1,1}, after: {3,2,2,1}, code: {9,2,1,2}}]
  """
  def parse_input_part1(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.chunk_every(3)
    |> Enum.map(&parse_record/1)
  end

  defp parse_record([before, code, after_]) do
    [_, b1, b2, b3, b4 | _] = String.split(before, ["Before: [", ", ", "]"])
    [_, a1, a2, a3, a4 | _] = String.split(after_, ["After:  [", ", ", "]"])

    %{
      before: [b1, b2, b3, b4] |> Enum.map(&String.to_integer/1) |> List.to_tuple(),
      after: [a1, a2, a3, a4] |> Enum.map(&String.to_integer/1) |> List.to_tuple(),
      code: parse_code(code)
    }
  end

  def parse_input_part2(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_code/1)
  end

  defp parse_code(code) do
    code
    |> String.split(" ")
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

  def part1_verify, do: input("day16_part1") |> part1()
  def part2_verify, do: part2(input("day16_part1"), input("day16_part2")) |> elem(0)
end
