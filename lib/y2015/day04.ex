defmodule Y2015.Day04 do
  use Advent.Day, no: 4

  @doc """
  iex> Day04.part1("abcdef")
  609043

  iex> Day04.part1("pqrstuv")
  1048970
  """
  def part1(input), do: do_parts(input, 0, 16)
  def part2(input), do: do_parts(input, 0, 0)

  defp do_parts(input, counter, max) do
    # Five zeros translates to the first 20 bits being zero, six zeros is 24 bits.
    # I don't think Elixir can pluck just 20 bits, so take 24, and for the five zero case, we
    # don't care about last four bits?
    # This way we don't need to do the hexadecimal encoding at all
    <<val::size(24), _rest::binary>> = :erlang.md5("#{input}#{counter}")

    if val <= max do
      counter
    else
      do_parts(input, counter + 1, max)
    end
  end

  def part1_verify, do: part1("yzbqklnj")
  def part2_verify, do: part2("yzbqklnj")
end
