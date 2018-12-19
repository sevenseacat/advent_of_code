defmodule Y2018.Day18 do
  use Advent.Day, no: 18

  @symbols %{"." => :open, "|" => :tree, "#" => :lumberyard}

  @doc """
  iex> test_data("sample") |> Day18.part1(1)
  %{lumberyard: 12, tree: 40, open: 48}

  iex> test_data("sample") |> Day18.part1(10)
  %{tree: 37, lumberyard: 31, open: 32}
  """
  def part1(input, iterations) do
    summary =
      input
      |> parse_input()
      |> do_part1(0, iterations, %{})
      |> Enum.group_by(fn {_coord, type} -> type end)

    %{
      tree: Map.get(summary, :tree) |> length,
      lumberyard: Map.get(summary, :lumberyard) |> length,
      open: Map.get(summary, :open) |> length
    }
  end

  defp do_part1(input, max, max, _), do: input

  defp do_part1(input, iterations, max_iterations, previous) do
    new_input =
      input
      |> Enum.map(fn coord -> tick(coord, input) end)
      |> Enum.into(%{})

    # If we've seen this exact field layout before, we've hit a cycle in the input
    # We can then skip a whole lot of iterations until we get close to the final number.
    {previous, iterations} =
      if seen_at = Map.get(previous, new_input) do
        cycles_to_skip = div(max_iterations - iterations, iterations - seen_at)
        {previous, iterations + cycles_to_skip * (iterations - seen_at)}
      else
        {Map.put(previous, new_input, iterations), iterations}
      end

    do_part1(new_input, iterations + 1, max_iterations, previous)
  end

  defp tick({coord, type}, map) do
    surrounds = get_surrounding_coords(coord, map)
    {coord, convert_unit(type, surrounds)}
  end

  defp get_surrounding_coords({x, y}, map) do
    [
      {x - 1, y},
      {x - 1, y + 1},
      {x, y + 1},
      {x + 1, y + 1},
      {x + 1, y},
      {x + 1, y - 1},
      {x, y - 1},
      {x - 1, y - 1}
    ]
    |> Enum.map(fn coord -> Map.get(map, coord) end)
    |> Enum.filter(fn type -> type != nil end)
  end

  defp convert_unit(:open, surrounds) do
    if surrounds |> Enum.filter(&(&1 == :tree)) |> Enum.count() >= 3, do: :tree, else: :open
  end

  defp convert_unit(:tree, surrounds) do
    if surrounds |> Enum.filter(&(&1 == :lumberyard)) |> Enum.count() >= 3,
      do: :lumberyard,
      else: :tree
  end

  defp convert_unit(:lumberyard, surrounds) do
    if Enum.member?(surrounds, :lumberyard) && Enum.member?(surrounds, :tree),
      do: :lumberyard,
      else: :open
  end

  @doc """
  iex> test_data("sample_small") |> Day18.parse_input()
  %{{0,0} => :tree, {0,1} => :lumberyard, {0,2} => :open,
    {1,0} => :lumberyard, {1,1} => :lumberyard, {1,2} => :lumberyard,
    {2,0} => :open, {2,1} => :tree, {2,2} => :open}
  """
  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.reduce({%{}, 0}, fn row, {acc, y} ->
      {row
       |> String.graphemes()
       |> Enum.reduce({acc, 0}, fn col, {acc, x} ->
         {Map.put(acc, {x, y}, @symbols[col]), x + 1}
       end)
       |> elem(0), y + 1}
    end)
    |> elem(0)
  end

  def part1_verify do
    %{lumberyard: lumberyard, tree: tree} = input() |> part1(10)
    lumberyard * tree
  end

  def part2_verify do
    %{lumberyard: lumberyard, tree: tree} = input() |> part1(1_000_000_000)
    lumberyard * tree
  end
end
