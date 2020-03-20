defmodule Y2019.Day15 do
  use Advent.Day, no: 15

  alias Y2019.Intcode

  @grid_size 22
  # Inputs and what those inputs do to x/y co-ordinates
  @moves %{1 => {0, 1}, 2 => {0, -1}, 3 => {-1, 0}, 4 => {1, 0}}

  def part1(input, show \\ true) do
    program =
      input
      |> Intcode.from_string()
      |> Intcode.new()

    g = :digraph.new()
    :digraph.add_vertex(g, {0, 0})
    {graph, map} = do_part1([{{0, 0}, program}], g, %{{0, 0} => :start}, show)
    {win, _} = Enum.find(map, fn {_, key} -> key == :win end)

    # length is total number of positions in the path, movements is gaps between them
    length(:digraph.get_short_path(graph, {0, 0}, win)) - 1
  end

  def do_part1([], g, seen, _), do: {g, seen}

  def do_part1([{position, program} | rest], g, seen, show) do
    {seen, rest} =
      Enum.reduce(@moves, {seen, rest}, fn {input, change}, {seen, rest} ->
        {[output], new_program} =
          program
          |> Intcode.add_input(input)
          |> Intcode.run()
          |> Intcode.pop_outputs()

        case output do
          0 ->
            # Wall.
            {Map.put(seen, new_position(position, change), :wall), rest}

          1 ->
            # Space.
            new_position = new_position(position, change)

            if Map.has_key?(seen, new_position) do
              {seen, rest}
            else
              :digraph.add_vertex(g, new_position)
              :digraph.add_edge(g, position, new_position)
              :digraph.add_edge(g, new_position, position)
              {Map.put(seen, new_position, :space), [{new_position, new_program} | rest]}
            end

          2 ->
            # Found it!!
            new_position = new_position(position, change)
            :digraph.add_vertex(g, new_position)
            :digraph.add_edge(g, position, new_position)
            :digraph.add_edge(g, new_position, position)
            {Map.put(seen, new_position, :win), []}
        end
      end)

    if show, do: visualize(seen)

    do_part1(rest, g, seen, show)
  end

  defp new_position({x1, y1}, {x2, y2}), do: {x1 + x2, y1 + y2}

  defp visualize(state, path \\ []) do
    IEx.Helpers.clear()

    for y <- @grid_size..-@grid_size do
      for x <- -@grid_size..@grid_size do
        to_tile(Map.get(state, {x, y}), Enum.member?(path, {x, y}))
      end
      |> Enum.join()
    end
    |> Enum.each(&IO.puts/1)
  end

  defp to_tile(nil, _), do: " "
  defp to_tile(:wall, _), do: "#"
  defp to_tile(:space, true), do: "*"
  defp to_tile(:space, false), do: "."
  defp to_tile(:start, _), do: "X"
  defp to_tile(:win, _), do: "!"

  def part1_verify, do: input() |> part1(false)
end
