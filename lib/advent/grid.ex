defmodule Advent.Grid do
  def new(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.reduce(Map.new(), &parse_row/2)
  end

  def use_number_values(grid) do
    grid
    |> Enum.map(fn {coord, val} -> {coord, maybe_integer(val)} end)
    |> Map.new()
  end

  defp maybe_integer(val) do
    case Integer.parse(val) do
      :error -> val
      {num, _} -> num
    end
  end

  def size(grid) do
    coords = Map.keys(grid)
    {row, _} = Enum.max_by(coords, &elem(&1, 0))
    {_, col} = Enum.max_by(coords, &elem(&1, 1))

    {row, col}
  end

  def min(grid) do
    coords = Map.keys(grid)
    {row, _} = Enum.min_by(coords, &elem(&1, 0))
    {_, col} = Enum.min_by(coords, &elem(&1, 1))

    {row, col}
  end

  def corners(grid) do
    {min(grid), size(grid)}
  end

  defp parse_row({row, row_no}, map) do
    row
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.reduce(map, fn {col, col_no}, map ->
      Map.put(map, {row_no + 1, col_no + 1}, col)
    end)
  end

  def display(grid, highlight \\ []) do
    grid
    |> rows(highlight)
    |> Enum.map(&IO.puts/1)

    grid
  end

  def rows(grid, highlight \\ []) do
    vertices = Map.keys(grid)
    {{min_row, min_col}, {max_row, max_col}} = Enum.min_max(vertices)

    for row <- min_row..max_row, col <- min_col..max_col do
      if val = highlight?(highlight, {row, col}) do
        val
      else
        value = Map.get(grid, {row, col}, " ")

        case value do
          x when is_list(x) ->
            if(length(x) > 1, do: "#{length(x)}", else: hd(x))

          x ->
            "#{x}"
        end
      end
    end
    |> Enum.chunk_every(max_col - min_col + 1)
    |> Enum.map(fn row ->
      row
      |> Enum.filter(& &1)
      |> List.to_string()
    end)
  end

  defp highlight?(list, coord) when is_list(list) do
    if coord in list, do: colour("x")
  end

  defp highlight?(%MapSet{} = mapset, coord) do
    if MapSet.member?(mapset, coord), do: colour("x")
  end

  defp highlight?(map, coord) when is_map(map) do
    if val = Map.get(map, coord), do: colour(val)
  end

  defp colour(char) do
    # Red stands out most against white, at small and large text sizes
    IO.ANSI.red() <> "#{char}" <> IO.ANSI.reset()
  end
end
