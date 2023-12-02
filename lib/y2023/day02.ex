defmodule Y2023.Day02 do
  use Advent.Day, no: 02

  def part1(input) do
    max_red = 12
    max_green = 13
    max_blue = 14

    input
    |> Enum.filter(fn {_num, turns} ->
      Enum.all?(turns, fn {r, g, b} -> r <= max_red && g <= max_green && b <= max_blue end)
    end)
    |> Enum.map(fn {num, _} -> num end)
    |> Enum.sum()
  end

  # @doc """
  # iex> Day02.part2("update or delete me")
  # "update or delete me"
  # """
  # def part2(input) do
  #   input
  # end

  @doc """
  iex> Day02.parse_input("Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green")
  %{1 => [{4, 0, 3}, {1, 2, 6}, {0, 2, 0}]}
  """
  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.reduce(%{}, &parse_row/2)
  end

  defp parse_row(string, acc) do
    [game_number, games] = String.split(string, ": ")

    num = String.replace(game_number, "Game ", "") |> String.to_integer()

    games =
      String.split(games, "; ")
      |> Enum.map(&string_to_game/1)

    Map.put(acc, num, games)
  end

  defp string_to_game(string) do
    String.split(string, ", ")
    |> Enum.reduce({0, 0, 0}, fn string, {r, g, b} ->
      [num, colour] = String.split(string, " ")
      num = String.to_integer(num)

      case colour do
        "red" -> {r + num, g, b}
        "green" -> {r, g + num, b}
        "blue" -> {r, g, b + num}
      end
    end)
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  # def part2_verify, do: input() |> parse_input() |> part2()
end
