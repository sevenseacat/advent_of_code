defmodule Y2015.Day02 do
  use Advent.Day, no: 2

  def part1(input) do
    input
    |> parse_input
    |> Enum.map(&paper_required/1)
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> parse_input
    |> Enum.map(&ribbon_required/1)
    |> Enum.sum()
  end

  @doc """
  iex> Day02.paper_required([2, 3, 4])
  58

  iex> Day02.paper_required([1, 1, 10])
  43
  """
  def paper_required([w, l, h]) do
    sides = [w * l, l * h, h * w]
    Enum.sum(sides) * 2 + Enum.min(sides)
  end

  @doc """
  iex> Day02.ribbon_required([2, 3, 4])
  34

  iex> Day02.ribbon_required([1, 1, 10])
  14
  """
  def ribbon_required([w, l, h]) do
    %{
      (w * l) => 2 * w + 2 * l,
      (l * h) => 2 * l + 2 * h,
      (h * w) => 2 * h + 2 * w
    }
    |> Enum.min_by(fn {area, _} -> area end)
    |> elem(1)
    |> Kernel.+(w * l * h)
  end

  defp parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_row/1)
  end

  defp parse_row(row) do
    row
    |> String.split("x")
    |> Enum.map(&String.to_integer/1)
  end

  def part1_verify, do: data() |> part1()
  def part2_verify, do: data() |> part2()
end
