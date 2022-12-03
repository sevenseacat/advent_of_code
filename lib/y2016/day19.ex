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
    # MORE REVERSE ENGINEERING YOOOOOO
    # Once I had a formula that actually worked naively, I generated results for a whole bunch of
    # incrementing numbers to see if I could spot a pattern - and I did.
    # For all powers of 3, the winning elf is that number - ie. 9, 27, 81, 243, etc.
    # (Pity @elf_count isn't a power of 3.)
    # For numbers between powers of 3, the winning numbers start from 1 and increment for a time
    # by 1s, and then the rest by 2s to get to the power.
    # eg. 3 => 3, 4 => 1, 5 => 2, 6 => 3, 7 => 5, 8 => 7, 9 => 9
    # Is there a pattern to where they start increasing by 2 instead of 1?
    # YES - They start increasing by 2 after the previous power's result.
    # eg. 6 -> 3, 3 is 3^1, so after 6 the answers start increasing by 2.

    # So. The highest power of 3 lower than @elf_count is 1594323 (3^13).
    # So 1594323 => 1594323, then 1594324 => 1, 1594325 => 2.... up to 3188650 => 1594323, then they
    # will increase by twos.
    # So the answer is... (@elf_count - 1594323) = 1424135
    # AND IT IS. Verified by the Ruby version of the code I originally wrote that took 5 minutes to run,
    # and the site accepted as correct. And my doctests for smaller values.
    power = find_highest_power_of(3, 0, elf_count)
    elf_count - 3 ** power
  end

  defp find_highest_power_of(x, y, cap) do
    if x ** y > cap, do: y - 1, else: find_highest_power_of(x, y + 1, cap)
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
  def part2_verify, do: part2()
end
