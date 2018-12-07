defmodule Y2015.Day06 do
  use Advent.Day, no: 6

  def part1(input) do
    lights = do_parts(input, part1_cmds())

    :ets.match_object(lights, {:_, :_})
    |> Enum.map(fn {_, val} -> val end)
    |> Enum.sum()
  end

  @doc """
  iex> Day06.part2("turn on 0,0 through 0,0")
  1

  iex> Day06.part2("toggle 0,0 through 999,999")
  2000000
  """
  def part2(input) do
    lights = do_parts(input, part2_cmds())

    :ets.match_object(lights, {:_, :_})
    |> Enum.map(fn {_, val} -> val end)
    |> Enum.sum()
  end

  def part1_cmds do
    [
      on: fn coord, lights ->
        :ets.insert(lights, {coord, 1})
        lights
      end,
      off: fn coord, lights ->
        :ets.insert(lights, {coord, 0})
        lights
      end,
      toggle: fn coord, lights ->
        :ets.update_counter(lights, coord, {2, 1, 1, 0}, {coord, 0})
        lights
      end
    ]
  end

  def part2_cmds do
    [
      on: fn coord, lights ->
        :ets.update_counter(lights, coord, 1, {coord, 0})
        lights
      end,
      off: fn coord, lights ->
        # Second position in the tuple of {coord, val}, with a min of 0.
        # Defaults the inserted value to {coord, 0} *before* counting.
        :ets.update_counter(lights, coord, {2, -1, 0, 0}, {coord, 0})
        lights
      end,
      toggle: fn coord, lights ->
        :ets.update_counter(lights, coord, 2, {coord, 0})
        lights
      end
    ]
  end

  defp do_parts(input, cmds) do
    input
    |> parse_input
    |> run_commands(:ets.new(:day6, [:set]), cmds)
  end

  def run_commands([], lights, _), do: lights

  def run_commands([{cmd, [min, max]} | rest], lights, cmds) do
    lights =
      coordinate_range(min, max)
      |> Enum.reduce(lights, fn coord, lights ->
        Keyword.get(cmds, cmd).(coord, lights)
      end)

    run_commands(rest, lights, cmds)
  end

  defp coordinate_range({x1, y1}, {x2, y2}) do
    for x <- x1..x2, y <- y1..y2, do: {x, y}
  end

  @doc """
  iex> Day06.parse_input("turn on 0,0 through 999,999")
  [on: [{0, 0}, {999, 999}]]

  iex> Day06.parse_input("toggle 0,0 through 999,0")
  [toggle: [{0, 0}, {999, 0}]]
  """
  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_row/1)
  end

  defp parse_row(<<"turn on ", rest::binary>>), do: command(:on, rest)
  defp parse_row(<<"turn off ", rest::binary>>), do: command(:off, rest)
  defp parse_row(<<"toggle ", rest::binary>>), do: command(:toggle, rest)

  defp command(cmd, nums) do
    [x1, y1, x2, y2] =
      Regex.run(~r/(\d+),(\d+) through (\d+),(\d+)/, nums, capture: :all_but_first)

    {cmd,
     [
       {String.to_integer(x1), String.to_integer(y1)},
       {String.to_integer(x2), String.to_integer(y2)}
     ]}
  end

  def part1_verify, do: input() |> part1()
  def part2_verify, do: input() |> part2()
end
