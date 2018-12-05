defmodule Y2015.Day04 do
  use Advent.Day, no: 4

  @doc """
  iex> Day04.part1("abcdef")
  609043

  iex> Day04.part1("pqrstuv")
  1048970
  """
  def part1(input), do: do_parts(input, 0, "00000")
  def part2(input), do: do_parts(input, 0, "000000")

  defp do_parts(input, counter, prefix) do
    md5 = :crypto.hash(:md5, "#{input}#{counter}") |> Base.encode16()

    if String.starts_with?(md5, prefix) do
      counter
    else
      do_parts(input, counter + 1, prefix)
    end
  end

  def part1_verify, do: part1("yzbqklnj")
  def part2_verify, do: part2("yzbqklnj")
end
