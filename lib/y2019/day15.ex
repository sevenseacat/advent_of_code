defmodule Y2019.Day15 do
  use Advent.Day, no: 15

  alias Y2019.Intcode

  # Inputs and what those inputs do to x/y co-ordinates
  @moves %{1 => {0, 1}, 2 => {0, -1}, 3 => {-1, 0}, 4 => {1, 0}}

  def part1(input) do
    program =
      input
      |> Intcode.from_string()
      |> Intcode.new()

    {graph, map} = do_part1([{{0, 0}, program}], Graph.new(), %{{0, 0} => :start})
    {win, _} = Enum.find(map, fn {_, key} -> key == :win end)

    # length is total number of positions in the path, movements is gaps between them
    length(Graph.dijkstra(graph, {0, 0}, win)) - 1
  end

  def do_part1([], graph, state), do: {graph, state}

  def do_part1([{position, program} | rest], graph, state) do
    {state, graph, rest} =
      Enum.reduce(@moves, {state, graph, rest}, fn {input, change}, {state, graph, rest} ->
        {[output], new_program} =
          program
          |> Intcode.add_input(input)
          |> Intcode.run()
          |> Intcode.pop_outputs()

        case output do
          0 ->
            # Wall.
            {Map.put(state, new_position(position, change), :wall), graph, rest}

          1 ->
            # Space.
            new_position = new_position(position, change)

            if Map.has_key?(state, new_position) do
              {state, graph, rest}
            else
              {
                Map.put(state, new_position, :space),
                Graph.add_edge(graph, position, new_position),
                [{new_position, new_program} | rest]
              }
            end

          2 ->
            # Found it!!
            new_position = new_position(position, change)

            {
              Map.put(state, new_position, :win),
              Graph.add_edge(graph, position, new_position),
              []
            }
        end
      end)

    do_part1(rest, graph, state)
  end

  defp new_position({x1, y1}, {x2, y2}), do: {x1 + x2, y1 + y2}

  def visualize(state, path \\ []) do
    grid_size = 22
    IEx.Helpers.clear()

    for y <- grid_size..-grid_size do
      for x <- -grid_size..grid_size do
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

  def part1_verify, do: input() |> part1()
end
