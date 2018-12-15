defmodule Y2018.Day14 do
  use Advent.Day, no: 14

  @doc """
  iex> Day14.part1(9)
  "5158916779"

  iex> Day14.part1(5)
  "0124515891"

  iex> Day14.part1(18)
  "9251071085"

  iex> Day14.part1(2018)
  "5941429882"
  """
  def part1(input) do
    do_part1([0, 1], :array.from_list([3, 7]), input + 10, 2)
  end

  @doc """
  iex> Day14.part2("51589")
  9

  iex> Day14.part2("15891")
  10

  iex> Day14.part2("01245")
  5

  iex> Day14.part2("92510")
  18

  iex> Day14.part2("59414")
  2018
  """
  def part2(input) do
    do_part2([4, 3], :array.from_list([3, 7, 1, 0, 1, 0]), numbers(input), 6, 6)
  end

  defp numbers(input) do
    input
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
  end

  defp do_part1(elves, recipes, max_length, current_length) do
    if current_length >= max_length do
      read_string(recipes, max_length - 1, max_length - 10)
    else
      {elves, recipes, length} = generate_recipes(elves, recipes, current_length)
      do_part1(elves, recipes, max_length, length)
    end
  end

  defp do_part2(elves, recipes, matcher, count, length) do
    case check_string(recipes, matcher, count - length(matcher), count - 1) do
      true ->
        count - length(matcher)

      false ->
        {elves, recipes, length} = generate_recipes(elves, recipes, length)
        do_part2(elves, recipes, matcher, count + 1, length)
    end
  end

  defp generate_recipes([elf1, elf2], recipes, length) do
    [move1, move2] = next_recipe([elf1, elf2], recipes)

    new_recipes = Integer.digits(move1 + move2)

    {new_recipes, new_length} =
      new_recipes
      |> Enum.reduce({recipes, length}, fn recipe, {recipes, length} ->
        {:array.set(length, recipe, recipes), length + 1}
      end)

    elf1 = move(elf1, new_length, move1 + 1)
    elf2 = move(elf2, new_length, move2 + 1)

    {[elf1, elf2], new_recipes, new_length}
  end

  defp check_string(recipes, matcher, from, to) do
    res =
      Enum.reduce_while(from..to, matcher, fn index, [digit | digits] ->
        if :array.get(index, recipes) == digit, do: {:cont, digits}, else: {:halt, false}
      end)

    res == []
  end

  defp read_string(recipes, from, to) do
    Enum.reduce(from..to, "", fn index, acc ->
      "#{:array.get(index, recipes)}" <> acc
    end)
  end

  defp move(index, length, move) do
    rem(index + move, length)
  end

  defp next_recipe([e1, e2], recipes) do
    if e1 == e2 do
      elf = :array.get(e1, recipes)
      [elf, elf]
    else
      elf1 = :array.get(e1, recipes)
      elf2 = :array.get(e2, recipes)
      [elf1, elf2]
    end
  end

  def part1_verify, do: part1(702_831)
  def part2_verify, do: part2("702831")
end
