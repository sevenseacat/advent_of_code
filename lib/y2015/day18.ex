defmodule Y2015.Day18 do
  use Advent.Day, no: 18

  @loops 100

  def part1(input, loops \\ @loops) do
    do_parts(input, loops, & &1)
  end

  defp do_parts(input, loops, func) do
    result = loop(input, loops, 0, func)
    Enum.count(result, fn {coord, _val} -> Map.get(result, coord) == :on end)
  end

  def loop(input, loop, current_loop \\ 0, post_process)
  def loop(input, loop, loop, _post_process), do: input

  def loop(input, max_loops, current_loop, post_process) do
    {_, output} = Enum.reduce(input, {input, %{}}, fn x, acc -> process_coord(x, acc) end)

    output
    |> post_process.()
    |> loop(max_loops, current_loop + 1, post_process)
  end

  defp process_coord({coord, val}, {input, output}) do
    neighbours = get_neighbours(coord, input)
    {input, Map.put(output, coord, new_val(val, neighbours))}
  end

  defp get_neighbours({x, y}, input) do
    [
      {x + 1, y},
      {x + 1, y + 1},
      {x, y + 1},
      {x - 1, y + 1},
      {x - 1, y},
      {x - 1, y - 1},
      {x, y - 1},
      {x + 1, y - 1}
    ]
    |> Enum.map(fn coord -> Map.get(input, coord, :off) end)
  end

  defp new_val(:off, neighbours) do
    case Enum.count(neighbours, &(&1 == :on)) do
      3 -> :on
      _ -> :off
    end
  end

  defp new_val(:on, neighbours) do
    case Enum.count(neighbours, &(&1 == :on)) do
      x when x == 2 or x == 3 -> :on
      _ -> :off
    end
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.reduce(%{}, &parse_row/2)
  end

  # For visualization purposes only.
  def format_output(input) do
    row_size = input |> map_size() |> :math.sqrt() |> trunc

    for x <- 0..(row_size - 1) do
      for y <- 0..(row_size - 1) do
        if Map.get(input, {x, y}) == :on, do: "#", else: "."
      end
      |> Enum.join()
    end
    |> Enum.join("\n")
  end

  def parse_row({row, row_no}, acc) do
    row
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.reduce(acc, fn {val, col_no}, acc -> Map.put(acc, {row_no, col_no}, val(val)) end)
  end

  defp val("."), do: :off
  defp val("#"), do: :on

  def part1_verify, do: input() |> parse_input() |> part1()
end
