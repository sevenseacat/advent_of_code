defmodule Y2025.Day01 do
  use Advent.Day, no: 01

  @doc """
  iex> Day01.part1([-68, -30, 48, -5, 60, -55, -1, -99, 14, -82])
  3
  """
  def part1(input) do
    input
    |> Enum.reduce({0, 50}, fn turn, {count, position} ->
      new_position = rem(position + turn, 100)

      cond do
        new_position == 0 -> {count + 1, 0}
        new_position < 0 -> {count, 100 + new_position}
        true -> {count, new_position}
      end
    end)
    |> elem(0)
  end

  # @doc """
  # iex> Day01.part2("update or delete me")
  # "update or delete me"
  # """
  # def part2(input) do
  #   input
  # end

  @doc """
  iex> Day01.parse_input("L68\\nL30\\nR48\\nL5\\nR60\\nL55\\nL1\\nL99\\nR14\\nL82")
  [-68, -30, 48, -5, 60, -55, -1, -99, 14, -82]
  """
  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_turn/1)
  end

  defp parse_turn(<<"L", rest::binary>>), do: -1 * String.to_integer(rest)
  defp parse_turn(<<"R", rest::binary>>), do: String.to_integer(rest)

  def part1_verify, do: input() |> parse_input() |> part1()
  # def part2_verify, do: input() |> parse_input() |> part2()
end
