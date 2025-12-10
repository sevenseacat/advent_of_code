defmodule Y2025.Day09 do
  use Advent.Day, no: 09

  def part1(input) do
    input
    |> Advent.combinations(2)
    |> Enum.map(fn [a, b] -> {a, b, rectangle_size({a, b})} end)
    |> Enum.max_by(fn {_a, _b, size} -> size end)
    |> elem(2)
  end

  def part2(input) do
    edges = build_edges(input)

    input
    |> Advent.combinations(2)
    |> Enum.map(fn [a, b] -> {a, b, rectangle_size({a, b})} end)
    |> Enum.sort_by(fn {_a, _b, size} -> -size end)
    |> Enum.find(fn {a, b, _size} -> !any_exterior_edges?([a, b], edges) end)
    |> elem(2)
  end

  def build_edges(input) do
    cols =
      Enum.group_by(input, fn {_row, col} -> col end)
      |> Map.values()
      |> Enum.map(fn pair ->
        Enum.sort_by(pair, fn {row, _col} -> row end)
      end)

    rows =
      Enum.group_by(input, fn {row, _col} -> row end)
      |> Map.values()
      |> Enum.map(fn pair ->
        Enum.sort_by(pair, fn {_row, col} -> col end)
      end)

    Enum.reduce(rows ++ cols, [], fn
      [a, b], acc -> [[a, b] | acc]
      [a, b, c, d], acc -> [[a, b], [c, d] | acc]
    end)
  end

  # An exterior edge is an box edge that intersects with an outer edge,
  # or overlaps but is larger than an outer edge
  defp any_exterior_edges?([{row1, col1}, {row2, col2}], all_edges) do
    box_edges =
      build_edges([{row1, col1}, {row2, col2}, {row1, col2}, {row2, col1}])
      |> Enum.map(&Enum.sort/1)

    Enum.any?(box_edges, fn [a, b] ->
      Enum.any?(all_edges, fn [c, d] ->
        res =
          SegSeg.intersection(a, b, c, d)
          |> elem(1)

        res == :interior || (res == :edge && bigger_edge?([a, b], [c, d]))
      end)
    end)
  end

  defp bigger_edge?([{b_row1, col}, {b_row2, col}], [{e_row1, col}, {e_row2, col}]) do
    b_row1 < e_row1 || b_row2 > e_row2
  end

  defp bigger_edge?([{row, b_col1}, {row, b_col2}], [{row, e_col1}, {row, e_col2}]) do
    b_col1 < e_col1 || b_col2 > e_col2
  end

  @doc """
  iex> Day09.rectangle_size({{2,5}, {11,1}})
  50

  iex> Day09.rectangle_size({{7,3}, {2,3}})
  6
  """
  def rectangle_size({{row1, col1}, {row2, col2}}) do
    (abs(row2 - row1) + 1) * (abs(col2 - col1) + 1)
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn row ->
      row
      |> String.split(",", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  def part2_verify, do: input() |> parse_input() |> part2()
end
