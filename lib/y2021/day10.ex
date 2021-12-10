defmodule Y2021.Day10 do
  use Advent.Day, no: 10

  @char_mappings %{?( => ?), ?{ => ?}, ?< => ?>, ?[ => ?]}

  def part1(input) do
    input
    |> Enum.map(&corruption_info/1)
    |> Enum.filter(fn {status, _char, _to_close} -> status == :err end)
    |> Enum.map(fn {:err, char, _to_close} -> char_to_p1_value(char) end)
    |> Enum.sum()
  end

  def part2(input) do
    list =
      input
      |> Enum.map(&corruption_info/1)
      |> Enum.filter(fn {status, _char, to_close} -> status == :ok && to_close != '' end)
      |> Enum.map(fn {_status, _char, to_close} -> to_close end)
      |> Enum.map(&to_p2_score/1)
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
    Enum.reduce(charlist, 0, fn x, acc -> acc * 5 + char_to_p2_value(x) end)
  end

  defp char_to_p1_value(?)), do: 3
  defp char_to_p1_value(?]), do: 57
  defp char_to_p1_value(?}), do: 1197
  defp char_to_p1_value(?>), do: 25137

  defp char_to_p2_value(?)), do: 1
  defp char_to_p2_value(?]), do: 2
  defp char_to_p2_value(?}), do: 3
  defp char_to_p2_value(?>), do: 4

  @doc """
  iex> Day10.corruption_info("([])")
  {:ok, nil, ''}

  iex> Day10.corruption_info("[({(<(())[]>[[{[]{<()<>>")
  {:ok, nil, '}}]])})]'}

  iex> Day10.corruption_info("[(()[<>])]({[<{<<[]>>(")
  {:ok, nil, ')}>]})'}

  iex> Day10.corruption_info("{()()()>")
  {:err, ?>, '}'}

  iex> Day10.corruption_info("{([(<{}[<>[]}>{[]{[(<()>")
  {:err, ?}, ']>)])}'}

  iex> Day10.corruption_info("[[<[([]))<([[{}[[()]]]")
  {:err, ?), ']>]]'}

  iex> Day10.corruption_info("[({(<(())[]>[[{[]{<()<>>")
  {:ok, nil, '}}]])})]'}
  """
  def corruption_info(line, open \\ [])

  def corruption_info(<<>>, open), do: {:ok, nil, to_closing_string(open)}

  def corruption_info(<<char, rest::binary>>, open) do
    cond do
      opening_character?(char) -> corruption_info(rest, [char | open])
      matching_characters?(hd(open), char) -> corruption_info(rest, tl(open))
      true -> {:err, char, to_closing_string(open)}
    end
  end

  defp to_closing_string(open, closed \\ [])
  defp to_closing_string([], closed), do: Enum.reverse(closed)

  defp to_closing_string([char | rest], closed),
    do: to_closing_string(rest, [to_closing_char(char) | closed])

  defp opening_character?(char), do: Enum.member?(Map.keys(@char_mappings), char)
  defp matching_characters?(open, close), do: Map.get(@char_mappings, open) == close
  defp to_closing_char(char), do: Map.get(@char_mappings, char)

  def parse_input(input) do
    String.split(input, "\n", trim: true)
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  def part2_verify, do: input() |> parse_input() |> part2()
end
