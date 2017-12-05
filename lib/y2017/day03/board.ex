defmodule Y2017.Day03.Board do
  alias Y2017.Day03.Progress

  def build(input), do: do_build(Enum.into(1..input, []), [], Progress.new())

  defp do_build([_num], coordinates, _), do: coordinates

  defp do_build([num | nums], coordinates, progress) do
    {new_progress, new_coordinate} = Progress.increment(progress, coordinates, num)
    do_build(nums, [new_coordinate | coordinates], new_progress)
  end
end
