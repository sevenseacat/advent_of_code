defmodule Y2025.Day02 do
  use Advent.Day, no: 02

  @doc """
  iex> Day02.part1([{11, 22}, {95, 115}, {998, 1012}, {1188511880, 1188511890},
  ...> {222220, 222224}, {1698522, 1698528}, {446443, 446449}, {38593856, 38593862},
  ...> {565653, 565659}, {824824821, 824824827}, {2121212118, 2121212124}])
  1227775554
  """
  def part1(input) do
    input
    |> Enum.flat_map(&find_invalid/1)
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
  iex> Day02.find_invalid({11, 22})
  [11, 22]

  iex> Day02.find_invalid({95, 115})
  [99]

  iex> Day02.find_invalid({998, 1012})
  [1010]

  iex> Day02.find_invalid({1188511880, 1188511890})
  [1188511885]

  iex> Day02.find_invalid({222220, 222224})
  [222222]

  iex> Day02.find_invalid({1698522, 1698528})
  []

  iex> Day02.find_invalid({446443, 446449})
  [446446]

  iex> Day02.find_invalid({38593856, 38593862})
  [38593859]

  iex> Day02.find_invalid({565653, 565659})
  []

  iex> Day02.find_invalid({824824821, 824824827})
  []

  iex> Day02.find_invalid({2121212118, 2121212124})
  []
  """
  def find_invalid({from, to}) do
    # A precondition we can check
    from_string = Integer.to_string(from)
    to_string = Integer.to_string(to)

    # We need numbers that are an even number of digits
    if String.length(from_string) == String.length(to_string) &&
         rem(String.length(from_string), 2) != 0 do
      []
    else
      Enum.filter(from..to, &invalid?/1)
    end
  end

  defp invalid?(num) do
    num_string = Integer.to_string(num)
    length = String.length(num_string)

    if rem(length, 2) != 0 do
      false
    else
      {front, back} = String.split_at(num_string, div(length, 2))
      front == back
    end
  end

  @doc """
  iex> Day02.parse_input("11-22,95-115")
  [{11,22}, {95,115}]
  """
  def parse_input(input) do
    input
    |> String.split(",", trim: true)
    |> Enum.map(fn range ->
      range |> String.split("-") |> Enum.map(&String.to_integer/1) |> List.to_tuple()
    end)
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  # def part2_verify, do: input() |> parse_input() |> part2()
end
