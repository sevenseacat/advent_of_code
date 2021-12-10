defmodule Y2021.Day10 do
  use Advent.Day, no: 10

  def part1(input) do
    input
    |> Enum.map(&corruption_info/1)
    |> Enum.filter(fn {status, _char} -> status == :err end)
    |> Enum.map(fn {:err, char} -> char_to_value(char) end)
    |> Enum.sum()
  end

  defp char_to_value(?)), do: 3
  defp char_to_value(?]), do: 57
  defp char_to_value(?}), do: 1197
  defp char_to_value(?>), do: 25137

  @doc """
  iex> Day10.corruption_info("([])")
  {:ok, nil}

  iex> Day10.corruption_info("[({(<(())[]>[[{[]{<()<>>")
  {:ok, nil}

  iex> Day10.corruption_info("[(()[<>])]({[<{<<[]>>(")
  {:ok, nil}

  iex> Day10.corruption_info("{()()()>")
  {:err, ?>}

  iex> Day10.corruption_info("{([(<{}[<>[]}>{[]{[(<()>")
  {:err, ?}}

  iex> Day10.corruption_info("[[<[([]))<([[{}[[()]]]")
  {:err, ?)}
  """
  def corruption_info(line, open \\ [])

  def corruption_info(<<>>, _open), do: {:ok, nil}

  def corruption_info(<<char, rest::binary>>, open) do
    cond do
      opening_character?(char) -> corruption_info(rest, [char | open])
      matching_characters?(hd(open), char) -> corruption_info(rest, tl(open))
      true -> {:err, char}
    end
  end

  defp opening_character?(char), do: Enum.member?([?(, ?<, ?{, ?[], char)
  defp matching_characters?(?(, ?)), do: true
  defp matching_characters?(?[, ?]), do: true
  defp matching_characters?(?{, ?}), do: true
  defp matching_characters?(?<, ?>), do: true
  defp matching_characters?(_, _), do: false

  def parse_input(input) do
    String.split(input, "\n", trim: true)
  end

  def part1_verify, do: input() |> parse_input() |> part1()
end
