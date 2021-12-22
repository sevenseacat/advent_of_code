defmodule Y2021.Day22 do
  use Advent.Day, no: 22

  @doc """
  iex> Day22.part1([{:on, {10,12}, {10,12}, {10,12}}])
  27
  """
  def part1(input) do
    input
    |> Enum.filter(fn {_s, xs, ys, zs} ->
      in_small_range?(xs) && in_small_range?(ys) && in_small_range?(zs)
    end)
    |> run_steps(%{})
    |> Enum.count(fn {_coord, state} -> state == :on end)
  end

  defp in_small_range?({min, max}), do: min in -50..50 && max in -50..50

  defp run_steps([], state), do: state

  defp run_steps([{status, {min_x, max_x}, {min_y, max_y}, {min_z, max_z}} | steps], state) do
    state =
      for(x <- min_x..max_x, y <- min_y..max_y, z <- min_z..max_z, do: {x, y, z})
      |> Enum.reduce(state, fn coord, state -> turn(state, coord, status) end)

    run_steps(steps, state)
  end

  def turn(state, coord, status) do
    Map.put(state, coord, status)
  end

  @doc """
  iex> Day22.parse_input("on x=-3..43,y=-40..7,z=-4..40\\non x=-20..26,y=-14..40,z=-10..35\\n")
  [{:on, {-3,43}, {-40,7}, {-4, 40}}, {:on, {-20,26}, {-14,40}, {-10,35}}]
  """
  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [status, min_x, max_x, min_y, max_y, min_z, max_z] =
        Regex.run(~r/^(on|off) x=(-?\d+)..(-?\d+),y=(-?\d+)..(-?\d+),z=(-?\d+)..(-?\d+)$/, line,
          capture: :all_but_first
        )

      {
        String.to_atom(status),
        {num(min_x), num(max_x)},
        {num(min_y), num(max_y)},
        {num(min_z), num(max_z)}
      }
    end)
  end

  defp num(string) when is_binary(string), do: String.to_integer(string)

  def part1_verify, do: input() |> parse_input() |> part1()
end
