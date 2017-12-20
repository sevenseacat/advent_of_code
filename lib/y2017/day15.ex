defmodule Y2017.Day15 do
  use Advent.Day, no: 15

  @part_1_pair_count 40_000_000
  @part_2_pair_count 5_000_000
  @a_factor 16807
  @b_factor 48271

  @a_initial 634
  @b_initial 301

  alias Y2017.Day15.Generator

  @doc """
  iex> Day15.part1(65, 8921)
  588
  """
  def part1(a_initial \\ @a_initial, b_initial \\ @b_initial) do
    # IO.puts("Calculating A hashes...")
    a_values = Generator.new(a_initial, @a_factor) |> Enum.take(@part_1_pair_count)
    # IO.puts("Calculating B hashes...")
    b_values = Generator.new(b_initial, @b_factor) |> Enum.take(@part_1_pair_count)

    # IO.puts("Comparing hashes...")
    count_matches(tl(a_values), tl(b_values), 0)
  end

  @doc """
  iex> Day15.part2(65, 8921)
  309
  """
  def part2(a_initial \\ @a_initial, b_initial \\ @b_initial) do
    # IO.puts("Calculating A hashes...")
    a_values = Generator.new(a_initial, @a_factor, 4) |> Enum.take(@part_2_pair_count)
    # IO.puts("Calculating B hashes...")
    b_values = Generator.new(b_initial, @b_factor, 8) |> Enum.take(@part_2_pair_count)

    # IO.puts("Comparing hashes...")
    count_matches(tl(a_values), tl(b_values), 0)
  end

  defp count_matches([], [], count), do: count

  defp count_matches([a | a_values], [b | b_values], count) do
    <<a::little-16, _::binary>> = <<a::little-32>>
    <<b::little-16, _::binary>> = <<b::little-32>>

    count = if a == b, do: count + 1, else: count
    count_matches(a_values, b_values, count)
  end

  def part1_verify, do: part1()
  def part2_verify, do: part2()
end
