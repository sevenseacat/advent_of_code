defmodule Y2022.Day20 do
  use Advent.Day, no: 20

  @decryption_key 811_589_153

  @doc """
  iex> Day20.part1([1, 2, -3, 3, -2, 0, 4], 1)
  3
  """
  def part1(input, times \\ 1) do
    run_mixer(input, times)
  end

  @doc """
  iex> Day20.part2([1, 2, -3, 3, -2, 0, 4])
  1623178306
  """
  def part2(input) do
    input
    |> Enum.map(&(&1 * @decryption_key))
    |> run_mixer(10)
  end

  defp run_mixer(list, times) do
    length = length(list)
    list = mix(list, length, times)
    zero = Enum.find_index(list, &(&1 == 0))

    [1000, 2000, 3000]
    |> Enum.map(fn index ->
      Enum.at(list, rem(index + zero, length))
    end)
    |> Enum.sum()
  end

  @doc """
  # Different from example but functionally equivalent for a circular list
  iex> Day20.mix([1, 2, -3, 3, -2, 0, 4], 7, 1)
  [-2, 1, 2, -3, 4, 0, 3]

  iex> Day20.mix([811589153, 1623178306, -2434767459, 2434767459, -1623178306, 0, 3246356612], 7, 1)
  [0, -2434767459, 3246356612, -1623178306, 2434767459, 1623178306, 811589153]

  iex> Day20.mix([811589153, 1623178306, -2434767459, 2434767459, -1623178306, 0, 3246356612], 7, 2)
  [0, 2434767459, 1623178306, 3246356612, -2434767459, -1623178306, 811589153]

  # Different from example but functionally equivalent for a circular list
  iex> Day20.mix([811589153, 1623178306, -2434767459, 2434767459, -1623178306, 0, 3246356612], 7, 3)
  [2434767459, 3246356612, 1623178306, -1623178306, -2434767459, 0, 811589153]

  # Different from example but functionally equivalent for a circular list
  iex> Day20.mix([811589153, 1623178306, -2434767459, 2434767459, -1623178306, 0, 3246356612], 7, 10)
  [-2434767459, 1623178306, 3246356612, -1623178306, 2434767459, 811589153, 0]

  # My example testing what happens with duplicate numbers
  iex> Day20.mix([1, 2, -3, 3, -2, 0, 1], 7, 2)
  [-3, 3, 1, 1, 2, -2, 0]
  """
  def mix(list, length, times) do
    # Some numbers are duplicated in the real input and not in the sample input.
    # Fix that by pairing each of them with a unique number to tell them apart (order matters)
    list = Enum.map(list, fn key -> {key, System.unique_integer()} end)
    do_mix(list, list, length, times)
  end

  def do_mix(list, _og_list, _length, 0), do: Enum.map(list, &elem(&1, 0))

  def do_mix(list, og_list, length, times) do
    og_list
    |> Enum.reduce(list, fn {num, _} = key, list ->
      current_index = Enum.find_index(list, &(&1 == key))

      if current_index == nil do
        raise("Current index not found for #{inspect(key)} in #{inspect(list)}")
      end

      next_position = next_position(length: length, item: num, current: current_index)

      list
      |> List.delete(key)
      |> List.insert_at(next_position, key)
    end)
    |> do_mix(og_list, length, times - 1)
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

    # Decide the new position in the list
    case item + current do
      val when val <= 0 ->
        val - length * floor(val / length)

      val when val > length ->
        rem(val, length)

      val ->
        val
    end
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

  def part1_verify, do: input() |> parse_input() |> part1()
  def part2_verify, do: input() |> parse_input() |> part2()
end
