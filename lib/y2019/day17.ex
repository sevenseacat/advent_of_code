defmodule Y2019.Day17 do
  use Advent.Day, no: 17

  alias Advent.PathGrid
  alias Y2019.Intcode

  def part1(input) do
    input
    |> to_grid()
    |> find_intersections()
    |> to_alignment_parameter()
  end

  def part2(input) do
    # So we're going to use the intcode compiler twice - once to generate the grid and figure out
    # the path to take, then again with the updated input and feed it the chunked path we generated
    chunks =
      input
      |> to_intcode()
      |> Intcode.outputs()
      |> to_grid()
      |> find_path
      |> format_for_compiler()

    intcode =
      to_intcode(input, 2)
      |> Intcode.run()

    Enum.reduce(chunks, intcode, fn chunk, intcode ->
      case Intcode.status(intcode) do
        :paused ->
          intcode
          |> Intcode.add_inputs(chunk)
          |> Intcode.run()

        :halted ->
          raise "Error - unexpected halt of intcode program!"
      end
    end)
    |> Intcode.run()
    |> Intcode.outputs()
    # For some reason the outputs contains the whole printout of the grid, instead of just the output?
    # So grab the last value, which is the number to submit.
    |> List.last()
  end

  def format_for_compiler(path) do
    to_ascii(path)

    # Code for breaking up the generated path into its A,B,C chunks would go here...
    # ...if I could figure out how to do it.
    # Instead I figured it out manually.
    #
    # Original to_ascii(path) =
    # "R,4,R,10,R,8,R,4,R,10,R,6,R,4,R,4,R,10,R,8,R,4,R,10,R,6,R,4,R,4,L,12,R,6,
    #  L,12,R,10,R,6,R,4,R,4,L,12,R,6,L,12,R,4,R,10,R,8,R,4,R,10,R,6,R,4,R,4,
    #  L,12,R,6,L,12"
    #
    # Main = A,B,A,B,C,B,C,A,B,C
    # A = R,4,R,10,R,8,R,4
    # B = R,10,R,6,R,4
    # C = R,4,L,12,R,6,L,12
    [
      'A,B,A,B,C,B,C,A,B,C\n',
      'R,4,R,10,R,8,R,4\n',
      'R,10,R,6,R,4\n',
      'R,4,L,12,R,6,L,12\n',
      'N\n'
    ]
  end

  defp to_ascii(path) do
    path
    |> Enum.map(&to_char_code/1)
    |> Enum.join(",")
  end

  defp to_char_code(val) do
    case val do
      :right -> "R"
      :left -> "L"
      num when is_integer(num) -> Integer.to_string(num)
    end
  end

  def find_path(%PathGrid{graph: graph, units: [unit]}) do
    move(graph, unit.position, :up, [0, :up])
    |> Enum.reverse()
    |> Enum.drop(2)
  end

  def move(graph, position, facing, [move_count | rest] = path) do
    cond do
      forward_coord = valid_forward_coord(graph, position, facing) ->
        move(graph, forward_coord, facing, [move_count + 1 | rest])

      turn = turn(graph, position, facing) ->
        {turn_dir, facing} = turn
        move(graph, position, facing, [0, turn_dir | path])

      true ->
        # end of path reached
        path
    end
  end

  defp valid_forward_coord(graph, position, facing) do
    forward_coord = forward_coord(position, facing)
    if PathGrid.floor?(graph, forward_coord), do: forward_coord, else: nil
  end

  defp forward_coord({row, col}, facing) do
    case facing do
      :left -> {row, col - 1}
      :right -> {row, col + 1}
      :up -> {row - 1, col}
      :down -> {row + 1, col}
    end
  end

  defp turn(graph, position, facing) do
    graph
    |> adjacent_coords(position)
    |> Enum.reject(fn coord -> backward?(position, coord, facing) end)
    |> turn_direction(position, facing)
  end

  defp backward?({row, col}, coord, facing) do
    backward_coord =
      case facing do
        :left -> {row, col + 1}
        :right -> {row, col - 1}
        :up -> {row + 1, col}
        :down -> {row - 1, col}
      end

    backward_coord == coord
  end

  defp turn_direction([], _, _), do: nil

  defp turn_direction([{row1, col1}], {row2, col2}, old_facing) do
    new_facing =
      cond do
        row1 < row2 -> :up
        row1 > row2 -> :down
        col1 < col2 -> :left
        col1 > col2 -> :right
      end

    turn_dir =
      case {old_facing, new_facing} do
        {:left, :up} -> :right
        {:left, :down} -> :left
        {:right, :up} -> :left
        {:right, :down} -> :right
        {:up, var} when var in [:left, :right] -> var
        {:down, :left} -> :right
        {:down, :right} -> :left
      end

    {turn_dir, new_facing}
  end

  def to_grid(input) do
    input
    |> to_string()
    |> flip_symbols
    |> PathGrid.new()
  end

  def find_intersections(%PathGrid{graph: graph}) do
    graph
    |> Graph.vertices()
    |> Enum.filter(fn coord ->
      PathGrid.floor?(graph, coord) && length(adjacent_coords(graph, coord)) == 4
    end)
  end

  defp adjacent_coords(graph, {x, y}) do
    [{x - 1, y}, {x, y - 1}, {x + 1, y}, {x, y + 1}]
    |> Enum.filter(fn coord -> PathGrid.floor?(graph, coord) end)
  end

  defp to_alignment_parameter(list) do
    Enum.reduce(list, 0, fn {x, y}, acc -> acc + (x - 1) * (y - 1) end)
  end

  defp to_intcode(input, first_char \\ 1) do
    input
    |> Intcode.from_string()
    |> Intcode.new()
    |> Intcode.update_program(0, first_char)
    |> Intcode.run()
  end

  defp flip_symbols(input) do
    input
    # random third character
    |> String.replace(".", "x")
    |> String.replace("#", ".")
    |> String.replace("x", "#")
  end

  def part1_verify, do: input() |> to_intcode() |> Intcode.outputs() |> part1()
  def part2_verify, do: input() |> part2()
end
