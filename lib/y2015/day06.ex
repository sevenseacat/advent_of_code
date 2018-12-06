defmodule Y2015.Day06 do
  use Advent.Day, no: 6

  def part1(input) do
    do_parts(input, part1_cmds())
    |> Enum.count(fn {_, val} -> val end)
  end

  def part2(input) do
    do_parts(input,
      on: fn coord, lights -> Map.update(lights, coord, 1, &(&1 + 1)) end,
      off: fn coord, lights -> Map.update(lights, coord, 0, &max(&1 - 1, 0)) end,
      toggle: fn coord, lights -> Map.update(lights, coord, 2, &(&1 + 2)) end
    )
    |> Enum.map(fn {_, val} -> val end)
    |> Enum.sum()
  end

  def part1_cmds do
    [
      on: fn coord, lights -> Map.put(lights, coord, true) end,
      off: fn coord, lights -> Map.put(lights, coord, false) end,
      toggle: fn coord, lights -> Map.update(lights, coord, true, &(!&1)) end
    ]
  end

  defp do_parts(input, cmds) do
    input
    |> parse_input
    |> run_commands(%{}, cmds)
  end

  @doc """
  iex> Day06.run_commands([{:off, [{499,499}, {500,500}]}], %{{499, 499} => true}, Day06.part1_cmds())
  %{{499,499} => false, {499,500} => false, {500,499} => false, {500,500} => false}
  """
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
