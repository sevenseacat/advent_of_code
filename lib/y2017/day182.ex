defmodule Y2017.Day182 do
  use Advent.Day, no: 18

  alias Y2017.Day182.Program

  @doc """
  iex> Day182.run([{:send, 1}, {:send, 2}, {:send, :p}, {:receive, :a}, {:receive, :b},
  ...> {:receive, :c}, {:receive, :d}])
  [3, 3]
  """
  def run(cmds) do
    {:ok, a} = Program.new(:a, %{p: 0}, cmds)
    {:ok, b} = Program.new(:b, %{p: 1}, cmds)

    Program.add_references(a, b)

    do_run(a, b)
  end

  defp do_run(a, b) do
    Program.next_command(a)
    Program.next_command(b)

    # Exit case - deadlock, both programs are waiting to be sent something
    if Program.waiting?(a) && Program.waiting?(b) do
      [Program.send_count(a), Program.send_count(b)]
    else
      do_run(a, b)
    end
  end

  @doc """
  This is the same as the original Day18.parse_input/1, except sound/recover are now send/receive.

  iex> Day182.parse_input("set a 1
  ...>add a 2
  ...>mul a a
  ...>mod a 5
  ...>snd a
  ...>set a 0
  ...>rcv a
  ...>jgz a -1
  ...>set a 1
  ...>jgz a -2")
  [{:assign, :a, 1}, {:add, :a, 2}, {:multiply, :a, :a}, {:modulo, :a, 5}, {:send, :a},
  {:assign, :a, 0}, {:receive, :a}, {:jump, :a, -1}, {:assign, :a, 1}, {:jump, :a, -2}]
  """
  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.split(&1, " "))
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(["snd", one]), do: {:send, String.to_atom(one)}
  defp parse_line(["rcv", one]), do: {:receive, String.to_atom(one)}

  defp parse_line([cmd, one, two]) do
    one =
      try do
        String.to_integer(one)
      rescue
        ArgumentError -> String.to_atom(one)
      end

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

  def part2_verify, do: input() |> parse_input() |> run() |> Enum.at(1)
end
