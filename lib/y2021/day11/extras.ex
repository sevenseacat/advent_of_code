defmodule Y2021.Day11.Grid do
  defstruct map: %{}

  def new(map), do: %__MODULE__{map: map}
end

defimpl Inspect, for: Y2021.Day11.Grid do
  import Inspect.Algebra
  alias Y2021.Day11.Grid

  def inspect(%Grid{map: map}, _opts) do
    size = :math.sqrt(map_size(map)) |> trunc

    for row <- 0..(size - 1) do
      for col <- 0..(size - 1) do
        Map.get(map, {row, col}) |> Integer.to_string() |> String.pad_leading(3, " ")
      end
      |> IO.iodata_to_binary()
    end
    |> Enum.intersperse(line())
    |> concat()
  end
end

# data = Day11.input("../../../test/y2021/input/day11") |> Day11.parse_input
