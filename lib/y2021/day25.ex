defmodule Y2021.Day25 do
  use Advent.Day, no: 25

  def part1(cucumbers) do
    {{max_x, _}, _} = Enum.max_by(cucumbers, fn {{x, _}, _val} -> x end)
    {{_, max_y}, _} = Enum.max_by(cucumbers, fn {{_, y}, _val} -> y end)
    do_part1(cucumbers, {max_x, max_y}, 1)
  end

  defp do_part1(cucumbers, max_size, move_count) do
    case run(cucumbers, max_size) do
      {:ok, cucumbers} -> do_part1(cucumbers, max_size, move_count + 1)
      :no_moves -> move_count
    end
  end

  def run(cucumbers, max_size) do
    {east_moves, cucumbers} = move(cucumbers, max_size, :e)
    {south_moves, cucumbers} = move(cucumbers, max_size, :s)
    total_moves = east_moves + south_moves
    if total_moves > 0, do: {:ok, cucumbers}, else: :no_moves
  end

  defp move(cucumbers, max_size, :e) do
    do_move(cucumbers, max_size, :e, fn {row, col} -> {row, col + 1} end)
  end

  defp move(cucumbers, max_size, :s) do
    do_move(cucumbers, max_size, :s, fn {row, col} -> {row + 1, col} end)
  end

  defp do_move(cucumbers, max_size, facing, move_fn) do
    movable =
      for {coord, type} <- cucumbers,
          type == facing,
          !Map.has_key?(cucumbers, wrap(move_fn.(coord), max_size)),
          do: coord

    cucumbers =
      Enum.map(cucumbers, fn {coord, val} ->
        if coord in movable do
          {wrap(move_fn.(coord), max_size), val}
        else
          {coord, val}
        end
      end)
      |> Map.new()

    {length(movable), cucumbers}
  end

  defp wrap({row, col}, {max_row, max_col}) do
    row = if row > max_row, do: 0, else: row
    col = if col > max_col, do: 0, else: col
    {row, col}
  end

  @doc """
  iex> Day25.parse_input(">v.\\n.>v\\n")
  %{{0,0} => :e, {0,1} => :s, {1,1} => :e, {1,2} => :s}
  """
  def parse_input(input) do
    for {row, row_no} <- Enum.with_index(String.split(input, "\n")),
        {col, col_no} <- Enum.with_index(String.graphemes(row)),
        col != "." do
      {{row_no, col_no}, cucumber_type(col)}
    end
    |> Enum.into(%{})
  end

  defp cucumber_type(">"), do: :e
  defp cucumber_type("v"), do: :s

  defp grid_val(:e), do: ">"
  defp grid_val(:s), do: "v"
  defp grid_val(nil), do: "."

  def show_grid(cucumbers, {max_row, max_col}) do
    for row <- 0..max_row do
      for col <- 0..max_col do
        grid_val(Map.get(cucumbers, {row, col}))
      end
      |> Enum.join()
      |> IO.puts()
    end

    IO.puts("-----")

    cucumbers
  end

  def part1_verify, do: input() |> parse_input() |> part1()
end
