defmodule Y2019.Day11 do
  use Advent.Day, no: 11

  alias Y2019.Intcode

  def part1(intcode) do
    do_paint(intcode, {Map.new(), {0, 0}}, 0, :up)
    |> map_size()
  end

  def part2(intcode) do
    do_paint(intcode, {Map.new(), {0, 0}}, 1, :up)
    |> visualize()
  end

  defp visualize(canvas) do
    {{{min_x, _}, _}, {{max_x, _}, _}} = Enum.min_max_by(canvas, fn {{x, _}, _} -> x end)
    {{{_, min_y}, _}, {{_, max_y}, _}} = Enum.min_max_by(canvas, fn {{_, y}, _} -> y end)

    for y <- max_y..min_y, x <- min_x..max_x do
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

  defp do_paint(intcode, {canvas, position}, input, dir) do
    intcode =
      intcode
      |> Intcode.add_input(input)
      |> Intcode.run()

    case Intcode.status(intcode) do
      :paused ->
        {[color, turn_dir], intcode} = Intcode.pop_outputs(intcode)
        # Update canvas and get new input
        canvas = Map.put(canvas, position, color)
        {new_position, new_dir} = turn_and_move(position, dir, turn_dir)
        new_colour = Map.get(canvas, new_position, 0)
        do_paint(intcode, {canvas, new_position}, new_colour, new_dir)

      :halted ->
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

  def part1_verify, do: input() |> Intcode.from_string() |> Intcode.new() |> part1()
  def part2_verify, do: input() |> Intcode.from_string() |> Intcode.new() |> part2()
end
