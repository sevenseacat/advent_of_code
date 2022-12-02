defmodule Y2020.Day15 do
  use Advent.Day, no: 15

  @input "20,9,11,0,1,2"

  @doc """
  iex> Day15.part1("0,3,6")
  436

  iex> Day15.part1("1,3,2")
  1

  iex> Day15.part1("2,1,3")
  10

  iex> Day15.part1("1,2,3")
  27

  iex> Day15.part1("2,3,1")
  78

  iex> Day15.part1("3,2,1")
  438

  iex> Day15.part1("3,1,2")
  1836
  """
  def part1(input), do: parts(input, 2020)
  def part2(input), do: parts(input, 30_000_000)

  defp parts(input, turns) do
    cache = parse_input(input)
    last_turn = map_size(cache) - 1
    last_spoken = Enum.find(cache, fn {_k, v} -> v == [last_turn] end) |> elem(0)
    do_parts(cache, last_spoken, last_turn + 1, turns)
  end

  defp do_parts(_cache, last, max_turns, max_turns), do: last

  defp do_parts(cache, last, turn, max_turns) do
    spoken =
      case Map.get(cache, last) do
        # Existing number
        [prev1, prev2] -> prev1 - prev2
        # New number
        _ -> 0
      end

    do_parts(Map.update(cache, spoken, [turn], &[turn, hd(&1)]), spoken, turn + 1, max_turns)
  end

  @doc """
  iex> Day15.parse_input("0,3,6")
  %{0 => [0], 3 => [1], 6 => [2]}
  """
  def parse_input(input) do
    input
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.with_index()
    |> Map.new(fn {k, v} -> {k, [v]} end)
  end

  def part1_verify, do: part1(@input)
  def part2_verify, do: part2(@input)
end
