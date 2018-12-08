defmodule Y2015.Day10 do
  use Advent.Day, no: 10

  @input 1_113_222_113

  @doc """
  iex> Day10.part1(1, 1)
  2

  iex> Day10.part1(1, 2)
  2

  iex> Day10.part1(1, 3)
  4

  iex> Day10.part1(1, 4)
  6

  iex> Day10.part1(1, 5)
  6
  """
  def part1(input, times) do
    input
    |> Integer.to_string()
    |> String.graphemes()
    |> look_and_say(times)
  end

  def look_and_say(input, 0), do: length(input)

  def look_and_say(input, times) do
    acc =
      input
      |> Enum.reduce({0, 0, []}, fn x, acc -> look_or_say(x, acc, times) end)

    # Process the last element of the list by tacking it onto the end of our run
    {_, _, result} = look_or_say(nil, acc, times)
    look_and_say(result, times - 1)
  end

  # First element - just mark it as the 'active' element
  defp look_or_say(x, {0, 0, seen}, _), do: {x, 1, seen}

  defp look_or_say(x, {curr, count, seen}, times) do
    if x != curr do
      seen =
        if rem(times, 2) == 0,
          do: [curr, Integer.to_string(count) | seen],
          else: [Integer.to_string(count), curr | seen]

      {x, 1, seen}
    else
      {x, count + 1, seen}
    end
  end

  def part1_verify, do: part1(@input, 40)
  def part2_verify, do: part1(@input, 50)
end
