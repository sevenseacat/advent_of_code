defmodule Y2024.Day05 do
  use Advent.Day, no: 05

  def part1({deps, manuals}) do
    manuals
    |> Enum.filter(&in_order?(&1, deps))
    |> Enum.map(fn manual ->
      Enum.at(manual, floor(length(manual) / 2))
    end)
    |> Enum.sum()
  end

  # @doc """
  # iex> Day05.part2("update or delete me")
  # "update or delete me"
  # """
  # def part2(input) do
  #   input
  # end

  def in_order?([], _), do: true

  def in_order?([num1 | rest], deps) do
    !Enum.any?(rest, fn num2 -> {num2, num1} in deps end) && in_order?(rest, deps)
  end

  def parse_input(input) do
    [deps, manuals] =
      input
      |> String.split("\n\n", trim: true, parts: 2)
      |> Enum.map(&String.split(&1, "\n", trim: true))

    {Enum.map(deps, &parse_dep/1), Enum.map(manuals, &parse_manual/1)}
  end

  defp parse_dep(string) do
    string
    |> String.split("|", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

  defp parse_manual(string) do
    string
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  # def part2_verify, do: input() |> parse_input() |> part2()
end
