defmodule Y2017.Day04 do
  use Advent.Day, no: 04

  def part1(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.filter(&valid_passphrase?/1)
    |> Enum.count()
  end

  def part2(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.filter(&valid_part2_passphrase?/1)
    |> Enum.count()
  end

  defp valid_passphrase?(string) do
    words = String.split(string)
    length(Enum.uniq(words)) == length(words)
  end

  @doc """
  iex> Day04.valid_part2_passphrase?("abcde fghij")
  true

  iex> Day04.valid_part2_passphrase?("abcde xyz ecdab")
  false

  iex> Day04.valid_part2_passphrase?("a ab abc abd abf abj")
  true

  iex> Day04.valid_part2_passphrase?("iiii oiii ooii oooi oooo")
  true

  iex> Day04.valid_part2_passphrase?("oiii ioii iioi iiio")
  false
  """
  def valid_part2_passphrase?(string) do
    words =
      string
      |> String.split()
      |> Stream.map(&String.to_charlist/1)
      |> Enum.map(&Enum.sort/1)

    length(Enum.uniq(words)) == length(words)
  end

  def part1_verify, do: input() |> part1()
  def part2_verify, do: input() |> part2()
end
