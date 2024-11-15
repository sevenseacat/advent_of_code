defmodule Y2016.Day18 do
  use Advent.Day, no: 18

  @input ".^^^^^.^^.^^^.^...^..^^.^.^..^^^^^^^^^^..^...^^.^..^^^^..^^^^...^.^.^^^^^^^^....^..^^^^^^.^^^.^^^.^^"

  def part1(input \\ @input, rows \\ 40) do
    Enum.reduce(1..(rows - 1), [parse_input(input)], fn _x, acc ->
      [next_row(hd(acc)) | acc]
    end)
    |> Enum.map(&count_safe/1)
    |> Enum.sum()
  end

  def next_row(row) do
    ([:s] ++ row ++ [:s])
    |> Enum.chunk_every(3, 1, :discard)
    |> Enum.map(&check_rules/1)
  end

  defp count_safe(row), do: Enum.count(row, fn char -> char == :s end)

  defp check_rules([:t, :t, :s]), do: :t
  defp check_rules([:s, :t, :t]), do: :t
  defp check_rules([:t, :s, :s]), do: :t
  defp check_rules([:s, :s, :t]), do: :t
  defp check_rules(_), do: :s

  defp parse_input(input) do
    input
    |> String.codepoints()
    |> Enum.map(&to_symbol/1)
  end

  defp to_symbol("."), do: :s
  defp to_symbol("^"), do: :t

  def part1_verify, do: part1()
  def part2_verify, do: part1(@input, 400_000)
end
