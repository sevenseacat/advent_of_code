defmodule Y2021.Day10 do
  use Advent.Day, no: 10

  @char_mappings %{?( => ?), ?{ => ?}, ?< => ?>, ?[ => ?]}
  @part1_points %{?) => 3, ?] => 57, ?} => 1197, ?> => 25137}
  @part2_points %{?) => 1, ?] => 2, ?} => 3, ?> => 4}

  def part1(input) do
    input
    |> Enum.map(&check_syntax/1)
    |> Enum.filter(fn {status, _char} -> status == :corrupt end)
    |> Enum.map(fn {:corrupt, char} -> Map.get(@part1_points, char) end)
    |> Enum.sum()
  end

  def part2(input) do
    list =
      input
      |> Enum.map(&check_syntax/1)
      |> Enum.filter(fn {status, _to_close} -> status == :incomplete end)
      |> Enum.map(fn {:incomplete, to_close} -> to_p2_score(to_close) end)
      |> Enum.sort()

    # Get the middle value of the list https://stackoverflow.com/a/33729229/560215
    list |> Enum.at((length(list) - 1) |> div(2))
  end

  @doc """
  iex> Day10.to_p2_score('])}>')
  294

  iex> Day10.to_p2_score('}}]])})]')
  288957
  """
  def to_p2_score(charlist) do
    Enum.reduce(charlist, 0, fn x, acc -> acc * 5 + Map.get(@part2_points, x) end)
  end

  @doc """
  iex> Day10.check_syntax("([])")
  {:ok, nil}

  iex> Day10.check_syntax("[({(<(())[]>[[{[]{<()<>>")
  {:incomplete, '}}]])})]'}

  iex> Day10.check_syntax("[(()[<>])]({[<{<<[]>>(")
  {:incomplete, ')}>]})'}

  iex> Day10.check_syntax("{()()()>")
  {:corrupt, ?>}

  iex> Day10.check_syntax("{([(<{}[<>[]}>{[]{[(<()>")
  {:corrupt, ?}}

  iex> Day10.check_syntax("[[<[([]))<([[{}[[()]]]")
  {:corrupt, ?)}
  """
  def check_syntax(line), do: do_check_syntax(line, [])

  defp do_check_syntax(<<>>, []), do: {:ok, nil}
  defp do_check_syntax(<<>>, open), do: {:incomplete, Enum.map(open, &to_closing_char/1)}

  defp do_check_syntax(<<char, rest::binary>>, open) do
    cond do
      opening_character?(char) -> do_check_syntax(rest, [char | open])
      matching_characters?(hd(open), char) -> do_check_syntax(rest, tl(open))
      true -> {:corrupt, char}
    end
  end

  defp opening_character?(char), do: Enum.member?(Map.keys(@char_mappings), char)
  defp matching_characters?(open, close), do: Map.get(@char_mappings, open) == close
  defp to_closing_char(char), do: Map.get(@char_mappings, char)

  def parse_input(input) do
    String.split(input, "\n", trim: true)
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  def part2_verify, do: input() |> parse_input() |> part2()
end
