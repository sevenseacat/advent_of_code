defmodule Y2017.Day03.Board do
  alias Y2017.Day03.{Coordinate, Progress}

  def build(input, fun) do
    do_build(Enum.into(1..input, []), [%Coordinate{}], Progress.new(), fun)
  end

  defp do_build([_num], coordinates, _, _), do: coordinates

  defp do_build([num | nums], coordinates, progress, fun) do
    {new_progress, new_coordinate} = Progress.increment(progress, coordinates, fun.(num))
    do_build(nums, [new_coordinate | coordinates], new_progress, fun)
  end
end
