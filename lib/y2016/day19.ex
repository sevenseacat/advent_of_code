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

  # Extras grabbed from https://www.reddit.com/r/adventofcode/comments/5pczxh/2016_day_19_part_2_request_for_test_result/
  iex> Day19.part2(65535)
  6486
  """
  def part2(elf_count \\ @elf_count) do
    1..elf_count
    |> Enum.to_list()
    |> round_steal(0, elf_count)
  end

  defp round_steal([one], _, _), do: one

  defp round_steal(list, position, size) do
    # This was never going to finish, without knowing if I had the algorithm right
    # (and there were many off-by-one errors)
    # So I wrote it in Ruby, which has mutable state.
    # 3000000 array deletions and indexes are still slow as hell,
    # but it runs and gave the answer.
    # I've copied the algorithm back here, but it will still never finish.
    if rem(size, 10000) == 0, do: IO.inspect(size)

    opposite_position = opposite(position, size)
    killer = Enum.at(list, position)
    killed = Enum.at(list, opposite_position)
    list = List.delete_at(list, opposite_position)

    # IO.puts(
    #  "elf #{killer} (pos #{position}) takes from elf #{killed} (pos #{opposite_position}) (elves left: #{size})"
    # )

    new_position = if killed < killer, do: position - 1, else: position
    position = if new_position + 1 == size - 1, do: 0, else: new_position + 1
    round_steal(list, position, size - 1)
  end

  defp opposite(position, size) do
    rem(div(size, 2) + position, size)
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
  # def part2_verify, do: part2()
end
