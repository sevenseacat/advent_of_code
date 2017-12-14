defmodule Y2017.Day10 do
  use Advent.Day, no: 10

  use Bitwise

  @doc """
  Run in a console like:
  ```
  lengths = File.read!("lib/advent/data/day_10") |> String.trim |> String.split(",") |> Enum.map(&String.to_integer/1)
  Day10.part1(Enum.to_list(0..255), lengths)
  ```

  iex> Day10.part1([0, 1, 2, 3, 4], [3, 4, 1, 5])
  12
  """
  def part1(input, lengths) do
    {input, 0, 0, lengths}
    |> do_parts
    |> elem(0)
    |> Enum.take(2)
    |> Enum.reduce(1, &(&1 * &2))
  end

  @doc """
  iex> Day10.part2("")
  "a2582a3a0e66e6e86e3812dcb672a272"

  iex> Day10.part2("AoC 2017")
  "33efeb34ea91902bb2f59c9920caa6cd"

  iex> Day10.part2("1,2,3")
  "3efbe78a8d82f29979031a4aa0b16a9d"

  iex> Day10.part2("1,2,4")
  "63960835bcdc130f0b66d7ff4f6a5a8e"
  """
  def part2(input) do
    input = parse_part2_input(input)

    {Enum.to_list(0..255), 0, 0, input}
    |> do_part2(input, 64)
    |> elem(0)
    |> Stream.chunk_every(16)
    |> Enum.map(&xor_everything!/1)
    |> Enum.join()
    |> String.downcase()
  end

  defp do_part2(data, _, 0), do: data

  defp do_part2(data, input, times) do
    data
    |> do_parts
    |> put_elem(3, input)
    |> do_part2(input, times - 1)
  end

  defp xor_everything!([head | rest]), do: xor(rest, head)
  defp xor([], result), do: result |> Integer.to_string(16) |> String.pad_leading(2, "0")
  defp xor([head | rest], result), do: xor(rest, bxor(head, result))

  defp do_parts({_, _, _, []} = data), do: data
  defp do_parts(data), do: data |> knot |> do_parts

  @doc """
  iex> Day10.parse_part2_input("1,2,3")
  [49, 44, 50, 44, 51, 17, 31, 73, 47, 23]
  """
  def parse_part2_input(input) do
    String.to_charlist(input) ++ [17, 31, 73, 47, 23]
  end

  @doc """
  List, position, skip size, lengths.

  iex> Day10.knot({[0, 1, 2, 3, 4], 0, 0, [3, 4, 1, 5]})
  {[2, 1, 0, 3, 4], 3, 1, [4, 1, 5]}

  iex> Day10.knot({[2, 1, 0, 3, 4], 3, 1, [4, 1, 5]})
  {[4, 3, 0, 1, 2], 3, 2, [1, 5]}

  iex> Day10.knot({[4, 3, 0, 1, 2], 3, 2, [1, 5]})
  {[4, 3, 0, 1, 2], 1, 3, [5]}

  iex> Day10.knot({[4, 3, 0, 1, 2], 1, 3, [5]})
  {[3, 4, 2, 1, 0], 4, 4, []}

  The ignore case
  iex> Day10.knot({[4, 3, 0, 1, 2], 1, 3, [6]})
  {[4, 3, 0, 1, 2], 1, 3, []}
  """
  def knot({list, position, skip_size, [length | lengths]}) when length > length(list) do
    {list, position, skip_size, lengths}
  end

  def knot({list, position, skip_size, [length | lengths]}) do
    {new_list, new_position} = reverse(list, list, position, length, length)
    {new_list, rem(new_position + skip_size, length(list)), skip_size + 1, lengths}
  end

  @doc """
  Reverses a section of a list by iterating over the elements to be replaced, replacing them with
  their "opposites" from the original list.
  There has to be a simpler way to calculate the opposite value...
  """
  def reverse(list, _, position, 0, _), do: {list, position}

  def reverse(list, orig_list, position, length, orig_length) do
    list
    |> List.replace_at(
      position,
      Enum.at(orig_list, rem(position + length - (orig_length - length) - 1, length(list)))
    )
    |> reverse(orig_list, rem(position + 1, length(list)), length - 1, orig_length)
  end

  def parse_input(input) do
    input |> String.split(",", trim: true) |> Enum.map(&String.to_integer/1)
  end

  def part1_verify, do: part1(Enum.to_list(0..255), input() |> parse_input())
  def part2_verify, do: input() |> part2()
end
