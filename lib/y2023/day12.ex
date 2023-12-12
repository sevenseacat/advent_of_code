defmodule Y2023.Day12 do
  use Advent.Day, no: 12

  def part1(input) do
    input
    |> Enum.map(fn row ->
      row
      |> possibilities()
      |> length()
    end)
    |> Enum.sum()
  end

  # @doc """
  # iex> Day12.part2("update or delete me")
  # "update or delete me"
  # """
  # def part2(input) do
  #   input
  # end

  def possibilities(%{springs: springs, positions: positions}) do
    regex = ~r/^\.*#{position_regex(positions)}\.*$/

    unknown =
      springs
      |> Enum.with_index()
      |> Enum.filter(fn {s, _p} -> s == "?" end)

    unknown_length = length(unknown)

    if unknown_length == 0 do
      [Enum.join(springs)]
    else
      Advent.permutations_with_repetitions(["#", "."], unknown_length)
      |> Enum.map(fn replacements ->
        to_replaced_springs(springs, unknown, replacements)
      end)
      |> Enum.filter(fn springs -> Regex.match?(regex, springs) end)
    end
  end

  # Turn the list of positions into a regex string
  # eg. 1,1,3 becomes \#{1}\.+\#{1}\.+\#{3}
  defp position_regex(positions) do
    positions
    |> Enum.map(&"\#{#{&1}}")
    |> Enum.intersperse("\\.+")
    |> Enum.join()
  end

  defp to_replaced_springs(springs, unknown, replacements) do
    unknown
    |> Enum.with_index()
    |> Enum.reduce(springs, fn {{_, springs_index}, index}, acc ->
      List.replace_at(acc, springs_index, Enum.at(replacements, index))
    end)
    |> Enum.join()
  end

  def parse_input(input) do
    for row <- String.split(input, "\n", trim: true) do
      [springs, positions] = String.split(row, " ")

      %{
        springs: String.graphemes(springs),
        positions: String.split(positions, ",") |> Enum.map(&String.to_integer/1)
      }
    end
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  # def part2_verify, do: input() |> parse_input() |> part2()
end
