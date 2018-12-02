defmodule Y2018.Day02 do
  use Advent.Day, no: 2

  @doc """
  iex> Day02.part1(["abcdef", "bababc", "abbcde", "abcccd", "aabcdd", "abcdee", "ababab"])
  {4, 3}
  """
  def part1(input), do: do_part1(input, {0, 0})

  def do_part1([], result), do: result

  def do_part1([string | rest], {doubles, triples}) do
    do_part1(
      rest,
      {
        add_if_true(doubles, has_letter_count?(string, 2)),
        add_if_true(triples, has_letter_count?(string, 3))
      }
    )
  end

  def add_if_true(val, false), do: val
  def add_if_true(val, true), do: val + 1

  @doc """
  iex> Day02.has_letter_count?("abcdef", 2)
  false

  iex> Day02.has_letter_count?("bababc", 2)
  true

  iex> Day02.has_letter_count?("abbcde", 2)
  true

  iex> Day02.has_letter_count?("abcccd", 2)
  false

  iex> Day02.has_letter_count?("abcdef", 3)
  false

  iex> Day02.has_letter_count?("bababc", 3)
  true

  iex> Day02.has_letter_count?("abbcde", 3)
  false

  iex> Day02.has_letter_count?("abcccd", 3)
  true
  """
  def has_letter_count?(string, count) do
    letter =
      string
      |> String.graphemes()
      |> frequencies
      |> Enum.find(fn {_, v} -> v == count end)

    letter != nil
  end

  # https://www.rosettacode.org/wiki/Letter_frequency#Elixir
  defp frequencies(string) do
    Enum.reduce(string, Map.new(), fn c, acc -> Map.update(acc, c, 1, &(&1 + 1)) end)
  end

  def part1_verify do
    {a, b} = input() |> String.split("\n", trim: true) |> part1()
    a * b
  end
end
