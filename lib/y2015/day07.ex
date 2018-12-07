defmodule Y2015.Day07 do
  use Advent.Day, no: 7

  require Bitwise

  @doc """
  iex> Day07.part1("123 -> x\\n456 -> y\\nx AND y -> d\\nx OR y -> e\\nx LSHIFT 2 -> f\\n
  ...>y RSHIFT 2 -> g\\nNOT x -> h\\nNOT y -> i")
  %{"d" => 72, "e" => 507, "f" => 492, "g" => 114, "h" => 65412, "i" => 65079, "x" => 123, "y" => 456}

  iex> Day07.part1("12 -> x\\n1 OR x -> b\\nb -> a") |> Map.get("a")
  13
  """
  def part1(input) do
    input
    |> parse_input
    |> do_part1(%{})
  end

  def do_part1(cmds, acc) do
    new_acc = Enum.reduce(cmds, acc, &run_cmd/2)

    # Need to keep running all the commands until all of the values have propagated, eg.
    # if wire A gets a value near the end of the run, but is needed for a command
    # at the start of the run
    if acc == new_acc do
      new_acc
    else
      do_part1(cmds, new_acc)
    end
  end

  def run_cmd({:assign, x, key}, map) do
    x = v(x, map)

    if x == nil, do: map, else: Map.put(map, key, x)
  end

  def run_cmd({:and, [x, y], key}, map) do
    [x, y] = [v(x, map), v(y, map)]

    if x == nil || y == nil, do: map, else: Map.put(map, key, Bitwise.band(x, y))
  end

  def run_cmd({:or, [x, y], key}, map) do
    [x, y] = [v(x, map), v(y, map)]

    if x == nil || y == nil, do: map, else: Map.put(map, key, Bitwise.bor(x, y))
  end

  def run_cmd({:lshift, [x, y], key}, map) do
    [x, y] = [v(x, map), v(y, map)]

    if x == nil || y == nil, do: map, else: Map.put(map, key, Bitwise.bsl(x, y))
  end

  def run_cmd({:rshift, [x, y], key}, map) do
    [x, y] = [v(x, map), v(y, map)]

    if x == nil || y == nil, do: map, else: Map.put(map, key, Bitwise.bsr(x, y))
  end

  def run_cmd({:not, x, key}, map) do
    x = v(x, map)

    if x == nil, do: map, else: Map.put(map, key, 65535 - x)
  end

  defp v(key, _) when is_integer(key), do: key
  defp v(key, data), do: Map.get(data, key)

  @doc """
  iex> Day07.parse_input("NOT y -> i")
  [{:not, "y", "i"}]

  iex> Day07.parse_input("123 -> x")
  [{:assign, 123, "x"}]

  iex> Day07.parse_input("x AND y -> d")
  [{:and, ["x", "y"], "d"}]
  """
  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_row/1)
  end

  defp parse_row(<<"NOT ", rest::binary>>) do
    [x, y] = String.split(rest, " -> ")
    {:not, x, y}
  end

  defp parse_row(row) do
    [lhs, rhs] = String.split(row, " -> ")
    lhs = String.split(lhs, " ") |> parse_lhs

    put_elem(lhs, 2, rhs)
  end

  defp parse_lhs(["NOT", x]), do: {:not, maybe_int(x), nil}
  defp parse_lhs([x, "AND", y]), do: {:and, [maybe_int(x), maybe_int(y)], nil}
  defp parse_lhs([x, "OR", y]), do: {:or, [maybe_int(x), maybe_int(y)], nil}
  defp parse_lhs([x, "LSHIFT", y]), do: {:lshift, [maybe_int(x), maybe_int(y)], nil}
  defp parse_lhs([x, "RSHIFT", y]), do: {:rshift, [maybe_int(x), maybe_int(y)], nil}
  defp parse_lhs([x]), do: {:assign, maybe_int(x), nil}

  defp maybe_int(val), do: if(Regex.match?(~r/\d+/, val), do: String.to_integer(val), else: val)

  def part1_verify, do: input() |> part1()
end
