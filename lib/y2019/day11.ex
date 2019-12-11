defmodule Y2019.Day11 do
  use Advent.Day, no: 11

  alias Y2019.Day05

  def part1(array) do
    do_paint(array, {Map.new(), {0, 0}}, 0, :up, 0)
    |> map_size()
  end

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
