defmodule Y2016.Day19 do
  use Advent.Day, no: 19

  @elf_count 3_018_458

  @doc """
  iex> Day19.last_elf_standing(5)
  3
  """
  def last_elf_standing(elf_count \\ @elf_count) do
    Enum.to_list(1..elf_count)
    |> present_steal([])
  end

  defp present_steal([], [elf]), do: elf
  defp present_steal([elf], []), do: elf

  # There may be either 0 or 1 elves left, depending if the circle has an odd or even number to start with
  defp present_steal([elf], all_elves), do: present_steal([elf | Enum.reverse(all_elves)], [])
  defp present_steal([], all_elves), do: present_steal(Enum.reverse(all_elves), [])

  defp present_steal([elf1, _elf2 | rest], waiting) do
    present_steal(rest, [elf1 | waiting])
  end

  def part1_verify, do: last_elf_standing()
end
