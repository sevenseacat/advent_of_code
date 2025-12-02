defmodule Y2025.Day02 do
  use Advent.Day, no: 02

  @doc """
  iex> Day02.part1([{11, 22}, {95, 115}, {998, 1012}, {1188511880, 1188511890},
  ...> {222220, 222224}, {1698522, 1698528}, {446443, 446449}, {38593856, 38593862},
  ...> {565653, 565659}, {824824821, 824824827}, {2121212118, 2121212124}])
  1227775554
  """
  def part1(input), do: do_parts(input, &half/1)

  @doc """
  iex> Day02.part2([{11, 22}, {95, 115}, {998, 1012}, {1188511880, 1188511890},
  ...> {222220, 222224}, {1698522, 1698528}, {446443, 446449}, {38593856, 38593862},
  ...> {565653, 565659}, {824824821, 824824827}, {2121212118, 2121212124}])
  4174379265
  """
  def part2(input), do: do_parts(input, &all/1)

  defp do_parts(input, func) do
    input
    |> Task.async_stream(&find_invalid(&1, func))
    |> Enum.flat_map(fn {:ok, res} -> res end)
    |> Enum.sum()
  end

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

  iex> Day02.find_invalid({95, 115}, &Day02.all/1)
  [99, 111]
  """
  def find_invalid({from, to}, func \\ &half/1) do
    Enum.filter(from..to, &invalid?(&1, func))
  end

  defp invalid?(num, func) do
    digits = Integer.digits(num)

    func.(length(digits))
    |> Enum.any?(fn chunk_size ->
      digits
      |> Enum.chunk_every(chunk_size)
      |> Enum.uniq()
      |> length() == 1
    end)
  end

  def half(length) when rem(length, 2) == 0, do: [div(length, 2)]
  def half(_length), do: []

  def all(1), do: []

  def all(length) do
    1..div(length, 2)
    |> Enum.filter(fn num -> rem(length, num) == 0 end)
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
  def part2_verify, do: input() |> parse_input() |> part2()
end
