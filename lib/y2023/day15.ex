defmodule Y2023.Day15 do
  use Advent.Day, no: 15

  @doc """
  iex> Day15.part1(['rn=1', 'cm-', 'qp=3', 'cm=2', 'qp-', 'pc=4', 'ot=9',
  ...>  'ab=5', 'pc-', 'pc=6', 'ot=7'])
  1320
  """
  def part1(input) do
    input
    |> Enum.map(&hash/1)
    |> Enum.sum()
  end

  # @doc """
  # iex> Day15.part2("update or delete me")
  # "update or delete me"
  # """
  # def part2(input) do
  #   input
  # end

  @doc """
  iex> Day15.hash('rn=1')
  30

  iex> Day15.hash('cm-')
  253

  iex> Day15.hash('qp=3')
  97
  """
  def hash(string) do
    string
    |> Enum.reduce(0, fn char, acc ->
      rem((acc + char) * 17, 256)
    end)
  end

  @doc """
  iex> Day15.parse_input("rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7")
  ['rn=1', 'cm-', 'qp=3', 'cm=2', 'qp-', 'pc=4', 'ot=9', 'ab=5', 'pc-', 'pc=6', 'ot=7']
  """
  def parse_input(input) do
    input
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_charlist/1)
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  # def part2_verify, do: input() |> parse_input() |> part2()
end
