defmodule Y2023.Day01 do
  use Advent.Day, no: 01

  @word_to_number %{
    "one" => "1",
    "two" => "2",
    "three" => "3",
    "four" => "4",
    "five" => "5",
    "six" => "6",
    "seven" => "7",
    "eight" => "8",
    "nine" => "9"
  }

  @doc """
  iex> Day01.part1(["1abc2", "pqr3stu8vwx", "a1b2c3d4e5f", "treb7uchet"])
  142
  """
  def part1(input) do
    input
    |> Enum.map(&to_integer/1)
    |> Enum.sum()
  end

  @doc """
  iex> Day01.part2(["two1nine", "eightwothree", "abcone2threexyz", "xtwone3four",
  ...> "4nineeightseven2", "zoneight234", "7pqrstsixteen"])
  281

  iex> Day01.part2(["fourtwone"])
  41
  """
  def part2(input) do
    input
    |> Enum.map(&to_part2_integer/1)
    |> Enum.sum()
  end

  defp to_integer(string) do
    numbers = Regex.replace(~r/[a-z]/, string, "")
    String.to_integer("#{String.first(numbers)}#{String.last(numbers)}")
  end

  defp to_part2_integer(string) do
    numbers =
      find_all_numbers(string, Enum.map(0..9, &to_string/1) ++ Map.keys(@word_to_number))
      |> Enum.filter(& &1)

    String.to_integer("#{List.first(numbers)}#{List.last(numbers)}")
  end

  defp find_all_numbers("", _matches), do: []

  # Some numbers may be overlapping! eg. "twone" has both two and one - two is first, one is last
  defp find_all_numbers(string, matches) do
    [
      as_number(Enum.find(matches, &String.starts_with?(string, &1)))
      | find_all_numbers(String.slice(string, 1..-1), matches)
    ]
  end

  def as_number(val), do: Map.get(@word_to_number, val, val)

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  def part2_verify, do: input() |> parse_input() |> part2()
end
