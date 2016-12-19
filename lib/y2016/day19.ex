defmodule Y2016.Day19 do
  use Advent.Day, no: 19

  @elf_count 3_018_458

  @doc """
  iex> Day19.last_elf_standing(5)
  3
  """
  def last_elf_standing(elf_count \\ @elf_count) do
    List.zip([Enum.to_list(1..elf_count), List.duplicate(1, elf_count)])
    |> present_steal([])
  end

  defp present_steal([], [{elf, _present_count}]), do: elf

  # There may be either 0 or 1 elves left, depending if the circle has an odd or even number to start with
  defp present_steal([elf], all_elves), do: present_steal([elf | Enum.reverse(all_elves)], [])
  defp present_steal([], all_elves), do: present_steal(Enum.reverse(all_elves), [])

  defp present_steal([{elf1_no, elf1_presents}, {_elf2_no, elf2_presents} | rest], waiting_elves) do
    elf1_presents = elf1_presents + elf2_presents
    present_steal(rest, [{elf1_no, elf1_presents} | waiting_elves])
  end

  def part1_verify, do: last_elf_standing()
end
