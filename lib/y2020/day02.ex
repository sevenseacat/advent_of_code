defmodule Y2020.Day02 do
  use Advent.Day, no: 2

  def part1(input) do
    Enum.count(input, &valid_old_password?/1)
  end

  def part2(input) do
    Enum.count(input, &valid_new_password?/1)
  end

  @doc """
  iex> Day02.valid_old_password?(%{min: 1, max: 3, letter: "a", password: "abcde"})
  true

  iex> Day02.valid_old_password?(%{min: 1, max: 2, letter: "b", password: "cdefg"})
  false
  """
  def valid_old_password?(%{min: min, max: max, letter: letter, password: password}) do
    count =
      password
      |> String.graphemes()
      |> Enum.filter(fn l -> l == letter end)
      |> length

    count >= min && count <= max
  end

  @doc """
  iex> Day02.valid_new_password?(%{min: 1, max: 3, letter: "a", password: "abcde"})
  true

  iex> Day02.valid_new_password?(%{min: 2, max: 9, letter: "c", password: "ccccccccc"})
  false
  """
  def valid_new_password?(%{min: min, max: max, letter: letter, password: password}) do
    min_match = String.at(password, min - 1) == letter
    max_match = String.at(password, max - 1) == letter

    # No native xor?
    (min_match || max_match) && min_match != max_match
  end

  @doc """
  iex> Day02.parse_input("1-3 a: abcde\\n2-7 b: cdefg")
  [%{min: 1, max: 3, letter: "a", password: "abcde"}, %{min: 2, max: 7, letter: "b", password: "cdefg"}]
  """
  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_row/1)
  end

  defp parse_row(row) do
    [[min, max, letter, password]] =
      Regex.scan(
        ~r/(\d+)-(\d+) (\w+): (\w+)/,
        row,
        capture: :all_but_first
      )

    %{
      min: String.to_integer(min),
      max: String.to_integer(max),
      letter: letter,
      password: password
    }
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  def part2_verify, do: input() |> parse_input() |> part2()
end
