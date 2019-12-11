defmodule Y2019.Day11 do
  use Advent.Day, no: 11

  alias Y2019.Day05

  def part1(array) do
    do_paint(array, {Map.new(), {0, 0}}, 0, :up, 0)
    # |> map_size()
    |> visualize()
  end

  def part2(array) do
    do_paint(array, {Map.new(), {0, 0}}, 1, :up, 0)
    |> visualize()
  end

  defp visualize(canvas) do
    {{{min_x, _}, _}, {{max_x, _}, _}} = Enum.min_max_by(canvas, fn {{x, _}, _} -> x end)
    {{{_, min_y}, _}, {{_, max_y}, _}} = Enum.min_max_by(canvas, fn {{_, y}, _} -> y end)

    for y <- max_y..min_y, x <- max_x..min_x do
      Map.get(canvas, {x, y}, 0)
    end
    |> Enum.chunk_every(max_x - min_x + 1)
    |> Enum.each(&display/1)
  end

  defp display(line) do
    line
    |> Enum.map(&to_pixel/1)
    |> IO.puts()
  end

  defp to_pixel(1), do: "."
  defp to_pixel(0), do: "X"

  defp do_paint(array, {canvas, position}, input, dir, intcode_pos) do
    case Day05.run_program(array, [input], intcode_pos) do
      {:pause, {array, [color, turn_dir], intcode_pos}} ->
        # Update canvas and get new input
        canvas = Map.put(canvas, position, color)
        {new_position, new_dir} = turn_and_move(position, dir, turn_dir)
        new_colour = Map.get(canvas, new_position, 0)
        do_paint(array, {canvas, new_position}, new_colour, new_dir, intcode_pos)

      {:halt, _} ->
        canvas
    end
  end

  defp turn_and_move(pos, current_dir, turn_dir) do
    new_dir = turn(current_dir, turn_dir)
    {move(new_dir, pos), new_dir}
  end

  defp turn(:up, 0), do: :left
  defp turn(:up, 1), do: :right
  defp turn(:down, 0), do: :right
  defp turn(:down, 1), do: :left
  defp turn(:left, 0), do: :down
  defp turn(:left, 1), do: :up
  defp turn(:right, 0), do: :up
  defp turn(:right, 1), do: :down
  defp move(:up, {x, y}), do: {x, y + 1}
  defp move(:left, {x, y}), do: {x - 1, y}
  defp move(:down, {x, y}), do: {x, y - 1}
  defp move(:right, {x, y}), do: {x + 1, y}

  def part1_verify, do: input() |> Day05.parse_input() |> part1()
end
