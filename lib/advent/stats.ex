defmodule Advent.Stats do
  def years, do: 2015..DateTime.utc_now().year

  def count_complete_puzzles(year) do
    for(day <- 25..1, part <- [2, 1], do: {day, part})
    |> Enum.filter(fn {day, part} -> complete?(year, day, part) end)
    |> Enum.count()
  end

  # You get the last star only if you have all 49 other stars.
  def complete?(year, 25, 2) do
    for(day <- 25..1, part <- [2, 1], do: {day, part})
    |> tl()
    |> Enum.all?(fn {day, part} -> complete?(year, day, part) end)
  end

  def complete?(year, day, part) do
    # Any completed puzzle will have a function defined like `Y2021.Day01.part1_verify/0`
    module_name = :"Elixir.Y#{year}.Day#{zero_pad(day)}"
    function_name = :"part#{part}_verify"

    Code.ensure_loaded(module_name)
    Kernel.function_exported?(module_name, function_name, 0)
  end

  defp zero_pad(day) when day < 10, do: "0#{day}"
  defp zero_pad(day), do: "#{day}"
end
