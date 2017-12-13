defmodule Y2017.Day10 do
  use Advent.Day, no: 10

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
    |> do_part1
    |> Enum.take(2)
    |> Enum.reduce(1, &(&1 * &2))
  end

  defp do_part1({list, _, _, []}), do: list
  defp do_part1(data), do: data |> knot |> do_part1

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
end
