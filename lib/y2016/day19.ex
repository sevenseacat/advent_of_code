defmodule Y2016.Day19 do
  use Advent.Day, no: 19

  @elf_count 3_018_458

  @doc """
  iex> Day19.part1(5)
  3
  """
  def part1(elf_count \\ @elf_count) do
    Enum.to_list(1..elf_count)
    |> present_steal([])
  end

  @doc """
  iex> Day19.part2(5)
  2
  """
  def part2(elf_count \\ @elf_count) do
    1..elf_count
    |> Enum.to_list()
    |> round_steal(0, elf_count)
  end

  defp round_steal([one], _, _), do: one

  defp round_steal(list, position, size) do
    if rem(size, 1000) == 0, do: IO.inspect(size)

    opposite_position = opposite(position, size)
    list = List.delete_at(list, opposite_position)
    next_position = if(position + 1 >= size, do: 0, else: position + 1)
    round_steal(list, next_position, size - 1)
  end

  defp opposite(position, size) do
    maybe = div(size, 2) + position
    if maybe >= size, do: maybe - size, else: maybe
  end

  defp present_steal([], [elf]), do: elf
  defp present_steal([elf], []), do: elf

  # There may be either 0 or 1 elves left, depending if the circle has an odd or even number to start with
  defp present_steal([elf], all_elves), do: present_steal([elf | Enum.reverse(all_elves)], [])
  defp present_steal([], all_elves), do: present_steal(Enum.reverse(all_elves), [])

  defp present_steal([elf1, _elf2 | rest], waiting) do
    present_steal(rest, [elf1 | waiting])
  end

  def part1_verify, do: part1()
end
