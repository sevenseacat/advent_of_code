defmodule Y2017.Day16 do
  use Advent.Day, no: 16

  @doc """
  iex> Day16.part1("abcde", [{:spin, 1}, {:exchange, 3, 4}, {:partner, "e", "b"}])
  "baedc"
  """
  def part1(programs, moves) do
    dance(String.codepoints(programs), moves) |> List.to_string()
  end

  @doc """
  iex> Day16.dance(["a", "b", "c", "d", "e"], [{:spin, 3}])
  ["c", "d", "e", "a", "b"]

  iex> Day16.dance(["a", "b", "c", "d", "e"], [{:exchange, 3, 4}])
  ["a", "b", "c", "e", "d"]

  iex> Day16.dance(["a", "b", "c", "d", "e"], [{:partner, "b", "d"}])
  ["a", "d", "c", "b", "e"]
  """
  def dance(programs, []), do: programs

  def dance(programs, [{:spin, spin} | rest]) do
    {head, tail} = Enum.split(programs, -spin)
    dance(tail ++ head, rest)
  end

  def dance(programs, [{:exchange, a, b} | rest]) do
    a_val = Enum.at(programs, a)
    b_val = Enum.at(programs, b)

    programs
    |> List.replace_at(a, b_val)
    |> List.replace_at(b, a_val)
    |> dance(rest)
  end

  def dance(programs, [{:partner, a, b} | rest]) do
    a_ind = Enum.find_index(programs, &(&1 == a))
    b_ind = Enum.find_index(programs, &(&1 == b))

    programs
    |> List.replace_at(a_ind, b)
    |> List.replace_at(b_ind, a)
    |> dance(rest)
  end

  @doc """
  iex> Day16.parse_input("s1,x3/4,pe/b")
  [{:spin, 1}, {:exchange, 3, 4}, {:partner, "e", "b"}]
  """
  def parse_input(input) do
    input
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(<<"s", size::binary>>) do
    {:spin, String.to_integer(size)}
  end

  defp parse_line(<<"x", rest::binary>>) do
    [one, two] = String.split(rest, "/")
    {:exchange, String.to_integer(one), String.to_integer(two)}
  end

  defp parse_line(<<"p", rest::binary>>) do
    [one, two] = String.split(rest, "/")
    {:partner, one, two}
  end

  def part1_verify, do: part1("abcdefghijklmnop", input() |> parse_input())
end
