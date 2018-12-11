# This wouldn't have been possible without Reddit and the hint that I wanted to use a summed-area table.
# https://en.wikipedia.org/wiki/Summed-area_table
# Well, it would have been, but my naive implementation literally took hours to come up with an answer.
# This takes a few seconds.
defmodule Y2018.Day11 do
  use Advent.Day, no: 11

  @serial 7400
  @max_size 300

  @doc """
  iex> Day11.part1(18)
  {{33, 45, 3}, 29}

  iex> Day11.part1(42)
  {{21, 61, 3}, 30}
  """
  def part1(serial \\ @serial) do
    serial
    |> build_grid
    |> max_by_summed_area_table(3, 3)
  end

  @doc """
  iex> Day11.part2(18)
  {{90,269,16}, 113}

  iex> Day11.part2(42)
  {{232,251,12}, 119}
  """
  def part2(serial \\ @serial) do
    serial
    |> build_grid
    |> max_by_summed_area_table(1, @max_size)
  end

  @doc """
  iex> Day11.cell_power({3, 5}, 8)
  4

  iex> Day11.cell_power({122, 79}, 57)
  -5

  iex> Day11.cell_power({217, 196}, 39)
  0

  iex> Day11.cell_power({101, 153}, 71)
  4
  """
  def cell_power({x, y}, serial) do
    rack_id = x + 10
    power_level = (rack_id * y + serial) * rack_id

    power_level
    |> div(100)
    |> rem(10)
    |> Kernel.-(5)
  end

  def build_grid(serial) do
    for x <- 1..@max_size, y <- 1..@max_size do
      {{x, y}, cell_power({x, y}, serial)}
    end
    |> Enum.into(%{})
  end

  defp max_by_summed_area_table(grid, min_size, max_size) do
    sat = summed_area_table(grid)

    min_size..max_size
    |> Enum.map(fn size -> max_grid_by_size(sat, size) end)
    |> Enum.max_by(fn {_, power} -> power end)
  end

  defp summed_area_table(grid) do
    Enum.reduce(@max_size..1, %{}, fn x, x_acc ->
      Enum.reduce(@max_size..1, x_acc, fn y, sat ->
        Map.put(
          sat,
          {x, y},
          Map.get(grid, {x, y}, 0) + Map.get(sat, {x + 1, y}, 0) + Map.get(sat, {x, y + 1}, 0) -
            Map.get(sat, {x + 1, y + 1}, 0)
        )
      end)
    end)
  end

  defp max_grid_by_size(sat, size) do
    sat
    # Only want full subgrids inside the 300x300 grid
    |> Stream.filter(fn {{x, y}, _} -> x + size - 1 <= @max_size && y + size - 1 <= @max_size end)
    |> Enum.map(fn {{x, y}, power} ->
      # The magic of the summed-area table at work. A + D - B - C.
      {{x, y, size},
       power + Map.get(sat, {x + size, y + size}, 0) - Map.get(sat, {x, y + size}, 0) -
         Map.get(sat, {x + size, y}, 0)}
    end)
    |> Enum.max_by(fn {_, power} -> power end)
  end

  def part1_verify, do: part1(@serial) |> elem(0)
  def part2_verify, do: part2(@serial) |> elem(0)
end
