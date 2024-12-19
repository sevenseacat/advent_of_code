defmodule Y2024.Day19 do
  use Advent.Day, no: 19

  def part1(%{from: from_towels, to: to_towels}) do
    Enum.count(to_towels, fn to ->
      can_make?(to, from_towels)
    end)
  end

  # @doc """
  # iex> Day19.part2("update or delete me")
  # "update or delete me"
  # """
  # def part2(input) do
  #   input
  # end

  defp can_make?(to, from_towels) do
    find_towel_list([{to, []}], from_towels) != nil
  end

  defp find_towel_list([], _from_towels), do: nil
  defp find_towel_list([{[], made} | _rest], _from_towels), do: Enum.reverse(made)

  defp find_towel_list([{to, made} | rest], from_towels) do
    new =
      from_towels
      |> Enum.filter(fn from -> List.starts_with?(to, from) end)
      |> Enum.map(fn from -> {Enum.drop(to, length(from)), [from | made]} end)

    find_towel_list(new ++ rest, from_towels)
  end

  def parse_input(input) do
    [from, to] = String.split(input, "\n\n", trim: true)

    %{
      from: String.split(from, ", ") |> Enum.map(&String.graphemes/1),
      to: String.split(to, "\n", trim: true) |> Enum.map(&String.graphemes/1)
    }
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  # def part2_verify, do: input() |> parse_input() |> part2()
end
