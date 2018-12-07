defmodule Y2018.Day07 do
  @doc """
  iex> Day07.part1([{"A", "C"}, {"F", "C"}, {"B", "A"}, {"D", "A"}, {"E", "B"}, {"E", "D"}, {"E", "F"}])
  "CABDFE"
  """
  def part1(input) do
  end

  def letters(input) do
    input
    |> Enum.reduce([], fn {x, y}, list -> [x, y | list] end)
    |> Enum.uniq()
    |> Enum.sort()
  end

  @doc """
  iex> Day07.parse_input("Step C must be finished before step A can begin.\\nStep C must be finished before step F can begin.")
  # Can be read as "A depends on C and F depends on C"
  [{"A", "C"}, {"F", "C"}]
  """
  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_row/1)
  end

  defp parse_row(
         <<"Step ", x::binary-1, " must be finished before step ", y::binary-1, " can begin.">>
       ) do
    {y, x}
  end
end
