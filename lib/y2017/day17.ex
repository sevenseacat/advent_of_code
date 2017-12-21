defmodule Y2017.Day17 do
  use Advent.Day, no: 17

  @doc """
  iex> Day17.part1(3)
  638
  """
  def part1(steps, limit \\ 2017) do
    {list, final_position} = do_part1({[0], 0}, 1, steps, limit)
    Enum.at(list, final_position + 1)
  end

  @doc """
  iex> Day17.part2(3, 9)
  9
  """
  def part2(steps, limit \\ 50_000_000) do
    do_part2(1, 1, 1, limit, steps)
  end

  def do_part2(after_zero, _, index, limit, _) when index > limit, do: after_zero

  def do_part2(after_zero, position, index, limit, step) do
    # The length of the list is the number being inserted.
    new_position = rem(position + step, index) + 1
    after_zero = if new_position == 1, do: index, else: after_zero
    do_part2(after_zero, new_position, index + 1, limit, step)
  end

  def iterate_for_zero([0, b | _rest]), do: b
  def iterate_for_zero([_a, b | rest]), do: iterate_for_zero([b | rest])

  defp do_part1(state, index, _, limit) when index > limit, do: state

  defp do_part1(state, index, steps, limit) do
    state
    |> insert(index, steps)
    |> do_part1(index + 1, steps, limit)
  end

  @doc """
  iex> Day17.insert({[0], 0}, 1, 3)
  {[0, 1], 1}

  iex> Day17.insert({[0, 1], 1}, 2, 3)
  {[0, 2, 1], 1}

  iex> Day17.insert({[0, 2, 1], 1}, 3, 3)
  {[0, 2, 3, 1], 2}

  iex> Day17.insert({[0, 2, 3, 1], 2}, 4, 3)
  {[0, 2, 4, 3, 1], 2}

  iex> Day17.insert({[0, 2, 4, 3, 1], 2}, 5, 3)
  {[0, 5, 2, 4, 3, 1], 1}

  iex> Day17.insert({[0, 5, 2, 4, 3, 1], 1}, 6, 3)
  {[0, 5, 2, 4, 3, 6, 1], 5}

  iex> Day17.insert({[0, 5, 2, 4, 3, 6, 1], 5}, 7, 3)
  {[0, 5, 7, 2, 4, 3, 6, 1], 2}
  """
  def insert({list, position}, number, step) do
    # The length of the list is the number being inserted.
    new_position = rem(position + step, number) + 1
    {List.insert_at(list, new_position, number), new_position}
  end

  def part1_verify, do: part1(386)
  def part2_verify, do: part2(386)
end
