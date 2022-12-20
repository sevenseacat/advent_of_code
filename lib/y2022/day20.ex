defmodule Y2022.Day20 do
  use Advent.Day, no: 20

  @doc """
  iex> Day20.part1([1, 2, -3, 3, -2, 0, 4], 1)
  3
  """
  def part1(input, times \\ 1) do
    length = length(input)
    mixed = mix(input, length, times)
    zero = Enum.find_index(mixed, &(&1 == 0))

    [1000, 2000, 3000]
    |> Enum.map(fn index ->
      Enum.at(mixed, rem(index + zero, length))
    end)
    |> Enum.sum()
  end

  # @doc """
  # iex> Day20.part2("update or delete me")
  # "update or delete me"
  # """
  # def part2(input) do
  #   input
  # end

  @doc """
  iex> Day20.mix([1, 2, -3, 3, -2, 0, 4], 7, 1)
  [1, 2, -3, 4, 0, 3, -2]
  """
  def mix(list, _length, 0), do: list

  def mix(list, length, times) do
    list = Enum.with_index(list)

    list
    |> Enum.reduce(list, fn {num, index}, list ->
      current_index = Enum.find_index(list, &(&1 == {num, index}))
      next_position = next_position(length: length, item: num, current: current_index)

      list
      |> List.delete({num, index})
      |> List.insert_at(next_position, {num, current_index})
    end)
    |> Enum.map(&elem(&1, 0))
    |> mix(length, times - 1)
  end

  @doc """
  The next position of an item depends on
  a) the current position in the list
  b) the length of the list and
  b) the value of the item itself.
  """
  def next_position(length: length, item: item, current: current) do
    # Take the item out of the list
    length = length - 1

    new_position =
      case item + current do
        val when val <= 0 ->
          val - length * floor(val / length)

        val when val > length ->
          rem(val, length)

        val ->
          val
      end

    # Put things at the end of the list, rather than the start.
    # It doesn't make an actual difference when calculating the result,
    # but the example does it that way
    if new_position == 0, do: length, else: new_position
  end

  @doc """
  # iex> Day20.parse_input("1\\n2\\n-3\\n3\\n-2\\n0\\n4")
  # [1, 2, -3, 3, -2, 0, 4]
  """
  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def part1_verify, do: input() |> parse_input() |> part1(1)
  # def part2_verify, do: input() |> parse_input() |> part2()
end
