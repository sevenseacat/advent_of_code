defmodule Y2017.Day15 do
  use Advent.Day, no: 15

  @a_factor 16807
  @b_factor 48271

  @a_initial 634
  @b_initial 301

  @doc """
  iex> Day15.part1(65, 8921)
  588
  """
  def part1(a_initial \\ @a_initial, b_initial \\ @b_initial) do
    do_loop({a_initial, nil}, {b_initial, nil}, 0, 40_000_000, 0)
  end

  @doc """
  iex> Day15.part2(65, 8921)
  309
  """
  def part2(a_initial \\ @a_initial, b_initial \\ @b_initial) do
    do_loop({a_initial, 4}, {b_initial, 8}, 0, 5_000_000, 0)
  end

  defp do_loop(_, _, iteration, iteration, count), do: count

  defp do_loop({a_val, a_divisor}, {b_val, b_divisor}, iteration, max_iteration, count) do
    a = next_val(a_val, @a_factor, a_divisor)
    b = next_val(b_val, @b_factor, b_divisor)

    do_loop(
      {a, a_divisor},
      {b, b_divisor},
      iteration + 1,
      max_iteration,
      compare_values(<<a::little-32>>, <<b::little-32>>, count)
    )
  end

  defp compare_values(<<a::16, _::binary>>, <<a::16, _::binary>>, count), do: count + 1
  defp compare_values(_, _, count), do: count

  @doc """
  iex> Day15.next_val(65, 16807, nil)
  1092455

  iex> Day15.next_val(1092455, 16807, nil)
  1181022009

  iex> Day15.next_val(1181022009, 16807, nil)
  245556042

  iex> Day15.next_val(8921, 48271, nil)
  430625591

  iex> Day15.next_val(430625591, 48271, nil)
  1233683848

  iex> Day15.next_val(1233683848, 48271, nil)
  1431495498
  """
  def next_val(val, factor, nil) do
    rem(val * factor, 2_147_483_647)
  end

  def next_val(val, factor, divisor) do
    val = rem(val * factor, 2_147_483_647)
    if rem(val, divisor) != 0, do: next_val(val, factor, divisor), else: val
  end

  def part1_verify, do: part1()
  def part2_verify, do: part2()
end
