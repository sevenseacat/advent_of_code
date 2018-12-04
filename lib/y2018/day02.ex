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
        inc_if_true(doubles, has_letter_count?(string, 2)),
        inc_if_true(triples, has_letter_count?(string, 3))
      }
    )
  end

  def inc_if_true(val, false), do: val
  def inc_if_true(val, true), do: val + 1

  @doc """
  iex> Day02.part2(["abcde", "fghij", "klmno", "pqrst", "fguij", "axcye", "wvxyz"])
  "fgij"
  """
  def part2([head | tail]) do
    case check_against_rest(head, tail) do
      nil -> part2(tail)
      value -> value
    end
  end

  def check_against_rest(_, []), do: nil

  def check_against_rest(subject, [possible | rest]) do
    if different_by_one?(subject, possible) do
      remove_different_letters(subject, possible)
    else
      check_against_rest(subject, rest)
    end
  end

  @doc """
  iex> Day02.different_by_one?("abcde", "axcye")
  false

  iex> Day02.different_by_one?("fghij", "fguij")
  true
  """
  def different_by_one?(str1, str2) do
    check_char_by_char(String.to_charlist(str1), String.to_charlist(str2), false)
  end

  defp check_char_by_char([], [], val), do: val

  # Early break - if we find a second character difference, no need to check any further
  defp check_char_by_char([h1 | _], [h2 | _], true) when h1 != h2, do: false

  defp check_char_by_char([h1 | t1], [h2 | t2], val) do
    check_char_by_char(t1, t2, val || h1 != h2)
  end

  def remove_different_letters(str1, str2) do
    Enum.zip(String.to_charlist(str1), String.to_charlist(str2))
    |> Enum.filter(fn {a, b} -> a == b end)
    |> Enum.map(fn {a, a} -> a end)
    |> List.to_string()
  end

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
    string
    |> String.to_charlist()
    |> frequencies
    |> Enum.any?(fn {_, v} -> v == count end)
  end

  # https://www.rosettacode.org/wiki/Letter_frequency#Elixir
  defp frequencies(string) do
    Enum.reduce(string, Map.new(), fn c, acc -> Map.update(acc, c, 1, &(&1 + 1)) end)
  end

  def part1_verify do
    {a, b} = input() |> String.split("\n", trim: true) |> part1()
    a * b
  end

  def part2_verify, do: input() |> String.split("\n", trim: true) |> part2()
end
