defmodule Y2018.Day17 do
  use Advent.Day, no: 17

  @doc """
  iex> Day17.part1("x=495, y=2..7\\ny=7, x=495..501\\nx=501, y=3..7\\nx=498, y=2..4\\nx=506, y=1..2\\nx=498, y=10..13\\nx=504, y=10..13\\ny=13, x=498..504")
  57
  """
  def part1(input) do
  end

  @doc """
  iex> Day17.parse_input("x=495, y=2..7\\ny=7, x=495..501\\nx=501, y=3..7\\nx=498, y=2..4\\nx=506, y=1..2\\nx=498, y=10..13\\nx=504, y=10..13\\ny=13, x=498..504")
  %{
    {506, 1} => :clay, {495, 2} => :clay, {498, 2} => :clay, {506, 2} => :clay,
    {495, 3} => :clay, {498, 3} => :clay, {501, 3} => :clay, {495, 4} => :clay,
    {498, 4} => :clay, {501, 4} => :clay, {495, 5} => :clay, {501, 5} => :clay,
    {495, 6} => :clay, {501, 6} => :clay, {495, 7} => :clay, {496, 7} => :clay,
    {497, 7} => :clay, {498, 7} => :clay, {499, 7} => :clay, {500, 7} => :clay,
    {501, 7} => :clay, {498, 10} => :clay, {504, 10} => :clay, {498, 11} => :clay,
    {504, 11} => :clay, {498, 12} => :clay, {504, 12} => :clay, {498, 13} => :clay,
    {499, 13} => :clay, {500, 13} => :clay, {501, 13} => :clay, {502, 13} => :clay,
    {503, 13} => :clay, {504, 13} => :clay
  }
  """
  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_row/1)
    |> Enum.reduce(%{}, &to_clay_field/2)
  end

  defp parse_row(row) do
    data =
      Regex.named_captures(
        ~r/(?<axis1>[x|y])=(?<axis1_var>\d+), (?<axis2>[x|y])=(?<axis2_min>\d+)\.\.(?<axis2_max>\d+)/,
        row
      )

    %{}
    |> Map.put(
      String.to_atom(data["axis1"]),
      String.to_integer(data["axis1_var"])..String.to_integer(data["axis1_var"])
    )
    |> Map.put(
      String.to_atom(data["axis2"]),
      String.to_integer(data["axis2_min"])..String.to_integer(data["axis2_max"])
    )
  end

  defp to_clay_field(%{x: x_range, y: y_range}, field) do
    for x <- x_range, y <- y_range do
      {{x, y}, :clay}
    end
    |> Enum.into(%{})
    |> Map.merge(field)
  end
end
