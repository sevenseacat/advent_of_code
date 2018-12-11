defmodule Y2018.Day11 do
  use Advent.Day, no: 11

  @serial 7400

  @doc """
  iex> Day11.part1(18)
  {{33, 45}, 29}

  iex> Day11.part1(42)
  {{21, 61}, 30}
  """
  def part1(serial \\ @serial) do
    build_grid({0, 0}, {300, 300}, serial)
    |> max_by({3, 3})
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

  @doc """
  iex> Day11.build_grid({32, 44}, {33, 45}, 18)
  %{{32, 44} => -2, {33, 44} => -4, {32, 45} => -4, {33, 45} => 4}
  """
  def build_grid({min_x, min_y}, {max_x, max_y}, serial) do
    for x <- min_x..max_x, y <- min_y..max_y do
      {{x, y}, cell_power({x, y}, serial)}
    end
    |> Enum.into(%{})
  end

  defp max_by(grid, {width, height}) do
    required_length = (width * height) |> IO.inspect()

    Enum.map(grid, fn {coord, _} ->
      subgrid = get_subgrid(grid, coord, width, height)
      # IO.inspect(Enum.sum(subgrid), label: "#{elem(coord, 0)},#{elem(coord, 1)}")

      case length(subgrid) do
        ^required_length -> {coord, Enum.sum(subgrid)}
        _ -> {coord, 0}
      end
    end)
    |> Enum.max_by(fn {_, y} -> y end)
  end

  defp get_subgrid(grid, {corner_x, corner_y}, width, height) do
    for x <- corner_x..(corner_x + width - 1),
        y <- corner_y..(corner_y + height - 1) do
      Map.get(grid, {x, y})
    end
    |> Enum.reject(fn v -> v == nil end)
  end

  def part1_verify, do: part1(@serial) |> elem(0)
end
