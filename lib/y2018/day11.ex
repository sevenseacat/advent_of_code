defmodule Y2018.Day11 do
  use Advent.Day, no: 11

  @serial 7400
  @max_size 300

  @doc """
  iex> Day11.part1(18)
  {{33, 45}, 29}

  iex> Day11.part1(42)
  {{21, 61}, 30}
  """
  def part1(serial \\ @serial) do
    build_grid({0, 0}, {@max_size, @max_size}, serial)
    |> max_by({3, 3})
  end

  def part1_ets(serial \\ @serial) do
    build_grid_ets({0, 0}, {@max_size, @max_size}, serial)
    |> all_maxes(3, 3)
  end

  @doc """
  iex> Day11.part2(18)
  {{90,269,16}, 113}

  iex> Day11.part2(42)
  {{232,251,12}, 119}
  """
  def part2(serial \\ @serial) do
    build_grid_ets({0, 0}, {@max_size, @max_size}, serial)
    |> all_maxes(1, 300)
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

  def build_grid_ets({min_x, min_y}, {max_x, max_y}, serial) do
    grid = :ets.new(:day112, [:set])

    for x <- min_x..max_x, y <- min_y..max_y do
      :ets.insert(grid, {{x, y}, cell_power({x, y}, serial)})
    end

    grid
  end

  defp all_maxes(grid, min_width, max_width) do
    min_width..max_width
    |> Task.async_stream(
      fn width ->
        Enum.reduce(1..(@max_size - width), {nil, 0}, fn x, {coord, power} ->
          {new_coord, new_power} =
            Enum.reduce(1..(@max_size - width), {nil, 0}, fn y, {coord, power} ->
              new_power = subgrid_power_ets(grid, {x, y}, width)

              if new_power > power do
                # IO.puts("new max is #{new_power} from #{x},#{y}")
                {{x, y, width}, new_power}
              else
                {coord, power}
              end
            end)

          if new_power > power do
            # IO.puts("new max is #{new_power} from #{elem(new_coord, 0)},#{elem(new_coord, 1)}")
            {new_coord, new_power}
          else
            {coord, power}
          end
        end)
      end,
      timeout: 600_000,
      max_concurrency: 10
    )
    |> Enum.max_by(fn {:ok, {_, power}} -> power end)
    |> elem(1)
  end

  defp max_by(grid, {width, height}) do
    Enum.map(grid, fn {{x, y}, _} ->
      if x + width > @max_size || y + height > @max_size do
        # skip it.
        {{x, y}, 0}
      else
        {{x, y}, subgrid_power(grid, {x, y}, width, height)}
      end
    end)
    |> Enum.max_by(fn {_, power} -> power end)
  end

  defp subgrid_power_ets(grid, {corner_x, corner_y}, size) do
    for x <- corner_x..(corner_x + size - 1),
        y <- corner_y..(corner_y + size - 1) do
      :ets.lookup(grid, {x, y})
    end
    |> Enum.reduce(0, fn [{_val, power}], acc -> acc + power end)
  end

  defp subgrid_power(grid, {corner_x, corner_y}, width, height) do
    for x <- corner_x..(corner_x + width - 1),
        y <- corner_y..(corner_y + height - 1) do
      Map.get(grid, {x, y})
    end
    |> Enum.sum()
  end

  def part1_verify, do: part1(@serial) |> elem(0)
  def part2_verify, do: part2(@serial) |> elem(0)
end
