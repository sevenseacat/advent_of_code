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

  defp do_part1([elf1, elf2], recipes, max_length, current_length) do
    if current_length >= max_length do
      # Read the last 10 digits out.
      Enum.reduce((max_length - 1)..(max_length - 10), "", fn index, acc ->
        "#{:array.get(index, recipes)}" <> acc
      end)
    else
      [move1, move2] = next_recipe([elf1, elf2], recipes)

      new_recipes = Integer.digits(move1 + move2)

      {new_recipes, new_length} =
        new_recipes
        |> Enum.reduce({recipes, current_length}, fn recipe, {recipes, length} ->
          {:array.set(length, recipe, recipes), length + 1}
        end)

      elf1 = move(elf1, new_length, move1 + 1)
      elf2 = move(elf2, new_length, move2 + 1)
      do_part1([elf1, elf2], new_recipes, max_length, new_length)
    end
  end

  defp move(index, length, move) do
    rem(index + move, length)
  end

  @doc """
  iex> Day14.next_recipe([0, 1], :array.from_list([3, 7]))
  [3, 7]

  iex> Day14.next_recipe([0, 1], :array.from_list([3, 7, 1, 0]))
  [3, 7]

  iex> Day14.next_recipe([4, 3], :array.from_list([3, 7, 1, 0, 1, 0]))
  [1, 0]
  """
  def next_recipe([e1, e2], recipes) do
    if e1 == e2 do
      elf = :array.get(e1, recipes)
      [elf, elf]
    else
      [i1, i2] = Enum.sort([e1, e2])
      elf1 = :array.get(i1, recipes)
      elf2 = :array.get(i2, recipes)

      if i1 == e1, do: [elf1, elf2], else: [elf2, elf1]
    end
  end

  def part1_verify, do: part1(702_831)
end
