defmodule Y2017.Day06 do
  use Advent.Day, no: 06

  @doc """
  iex> Day06.parts([0, 2, 7, 0])
  {[2,4,1,2], 5, 4}
  """
  def parts(input), do: parts(input, [input], 1)

  defp parts(input, seen_so_far, count) do
    new_input = redistribute(input)

    case Enum.member?(seen_so_far, new_input) do
      true -> {new_input, count, Enum.find_index(seen_so_far, &(&1 == new_input)) + 1}
      false -> parts(new_input, [new_input | seen_so_far], count + 1)
    end
  end

  @doc """
  iex> Day06.redistribute([0,2,7,0])
  [2,4,1,2]

  iex> Day06.redistribute([2,4,1,2])
  [3,1,2,3]

  iex> Day06.redistribute([3,1,2,3])
  [0,2,3,4]

  iex> Day06.redistribute([0,2,3,4])
  [1,3,4,1]

  iex> Day06.redistribute([1,3,4,1])
  [2,4,1,2]
  """
  def redistribute(banks) do
    max_blocks = Enum.max(banks)
    bank = Enum.find_index(banks, fn bank -> bank == max_blocks end)
    banks = List.replace_at(banks, bank, 0)

    # So we are now distributing max_blocks over the banks, starting with bank+1.
    put_blocks(banks, bank + 1, max_blocks, length(banks))
  end

  defp put_blocks(banks, _, 0, _), do: banks

  defp put_blocks(banks, bank_no, blocks, bank_count) when bank_no == bank_count do
    put_blocks(banks, 0, blocks, bank_count)
  end

  defp put_blocks(banks, bank_no, blocks, bank_count) do
    banks
    |> List.update_at(bank_no, &(&1 + 1))
    |> put_blocks(bank_no + 1, blocks - 1, bank_count)
  end

  def parse_input(data) do
    data
    |> String.trim()
    |> String.split()
    |> Enum.map(&String.to_integer/1)
  end

  def part1_verify, do: input() |> parse_input() |> parts() |> elem(1)
  def part2_verify, do: input() |> parse_input() |> parts() |> elem(2)
end
