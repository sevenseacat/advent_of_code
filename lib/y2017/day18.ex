defmodule Y2017.Day18 do
  use Advent.Day, no: 18

  @doc """
  iex> Day18.part1([{:assign, :a, 1}, {:add, :a, 2}, {:multiply, :a, :a}, {:modulo, :a, 5},
  ...> {:sound, :a}, {:assign, :a, 0}, {:recover, :a}, {:jump, :a, -1}, {:assign, :a, 1},
  ...> {:jump, :a, -2}])
  4
  """
  def part1(input) do
    try do
      do_part1(input, 0, %{}, nil)
    rescue
      e in RuntimeError -> String.to_integer(e.message)
    end
  end

  defp do_part1(cmds, index, data, sound) do
    {index, data, sound} = Enum.at(cmds, index) |> perform_command(index, data, sound)
    do_part1(cmds, index, data, sound)
  end

  defp perform_command({:add, one, two}, index, data, sound) do
    two = v(data, two)
    data = Map.update(data, one, two, &(&1 + two))
    {index + 1, data, sound}
  end

  defp perform_command({:assign, one, two}, index, data, sound) do
    two = v(data, two)
    data = Map.put(data, one, two)
    {index + 1, data, sound}
  end

  defp perform_command({:multiply, one, two}, index, data, sound) do
    two = v(data, two)
    data = Map.update(data, one, 0, &(&1 * two))
    {index + 1, data, sound}
  end

  defp perform_command({:modulo, one, two}, index, data, sound) do
    two = v(data, two)
    data = Map.update(data, one, 0, &rem(&1, two))
    {index + 1, data, sound}
  end

  defp perform_command({:sound, one}, index, data, _), do: {index + 1, data, v(data, one)}

  defp perform_command({:recover, one}, index, data, sound) do
    val = v(data, one)

    if val != 0 do
      raise Integer.to_string(sound)
    else
      {index + 1, data, sound}
    end
  end

  defp perform_command({:jump, one, two}, index, data, sound) do
    if v(data, one) > 0 do
      {index + v(data, two), data, sound}
    else
      {index + 1, data, sound}
    end
  end

  defp v(_, val) when is_integer(val), do: val
  defp v(data, val), do: Map.get(data, val, 0)

  @doc """
  iex> Day18.parse_input("set a 1
  ...>add a 2
  ...>mul a a
  ...>mod a 5
  ...>snd a
  ...>set a 0
  ...>rcv a
  ...>jgz a -1
  ...>set a 1
  ...>jgz a -2")
  [{:assign, :a, 1}, {:add, :a, 2}, {:multiply, :a, :a}, {:modulo, :a, 5}, {:sound, :a},
  {:assign, :a, 0}, {:recover, :a}, {:jump, :a, -1}, {:assign, :a, 1}, {:jump, :a, -2}]
  """
  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.split(&1, " "))
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(["snd", one]), do: {:sound, String.to_atom(one)}
  defp parse_line(["rcv", one]), do: {:recover, String.to_atom(one)}

  defp parse_line([cmd, one, two]) do
    one = String.to_atom(one)

    two =
      try do
        String.to_integer(two)
      rescue
        ArgumentError -> String.to_atom(two)
      end

    case cmd do
      "add" -> {:add, one, two}
      "mul" -> {:multiply, one, two}
      "mod" -> {:modulo, one, two}
      "set" -> {:assign, one, two}
      "jgz" -> {:jump, one, two}
    end
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  def part2_verify, do: Y2017.Day182.part2_verify()
end
