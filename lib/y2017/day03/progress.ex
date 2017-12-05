defmodule Y2017.Day03.Progress do
  alias Y2017.Day03.Coordinate

  # The ugly that stores the progress of the current position around the board.

  # To build the pattern:
  #   17  16  15  14  13
  #   18   5   4   3  12
  #   19   6   1   2  11
  #   20   7   8   9  10
  #   21  22  23---> ...
  # The sequence of moves is like:
  # run 1: 1 move right
  # run 2: 1 move up
  # run 3: 2 moves left
  # run 4: 2 moves down
  # run 5: 3 moves right
  # run 6: 3 moves up ... see where this is going?
  # So a progress state is { run number, direction, # of moves in run, current move # in run }
  def new do
    {1, {1, 0}, 1, 0}
  end

  def increment(progress, coordinates, fun) do
    new_progress = make_move(progress)
    {x, y} = move(new_progress, coordinates)
    {new_progress, %Coordinate{x: x, y: y, value: fun.({x, y}, coordinates)}}
  end

  defp make_move({run_no, direction, move_count, move_no}) do
    if move_count == move_no do
      new_move_count =
        case rem(run_no, 2) do
          0 -> move_count + 1
          1 -> move_count
        end

      {run_no + 1, rotate(direction), new_move_count, 1}
    else
      {run_no, direction, move_count, move_no + 1}
    end
  end

  defp move({_, {x1, y1}, _, _}, []), do: {x1, y1}
  defp move({_, {x1, y1}, _, _}, [%Coordinate{x: x2, y: y2} | _]), do: {x1 + x2, y1 + y2}

  defp rotate({1, 0}), do: {0, 1}
  defp rotate({0, 1}), do: {-1, 0}
  defp rotate({-1, 0}), do: {0, -1}
  defp rotate({0, -1}), do: {1, 0}
end
