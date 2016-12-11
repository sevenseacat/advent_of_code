defmodule Y2016.Day09 do
  use Advent.Day, no: 9

  @doc """
  iex> Day09.decompress("ADVENT")
  "ADVENT"

  iex> Day09.decompress("A(1x5)BC")
  "ABBBBBC"

  iex> Day09.decompress("(3x3)XYZ")
  "XYZXYZXYZ"

  iex> Day09.decompress("A(2x2)BCD(2x2)EFG")
  "ABCBCDEFEFG"

  iex> Day09.decompress("(6x1)(1x3)A")
  "(1x3)A"

  iex> Day09.decompress("X(8x2)(3x3)ABCY")
  "X(3x3)ABC(3x3)ABCY"
  """
  def decompress(string) do
    case String.split(string, "(", parts: 2) do
      [string] -> string
      [content, string] -> content <> duplicate_via_marker(string)
    end
  end

  @doc """
  iex> Day09.advanced_decompress_length("(3x3)XYZ")
  9 # XYZXYZYZ

  iex> Day09.advanced_decompress_length("X(8x2)(3x3)ABCY")
  20 # -> XABCABCABCABCABCABCY

  iex> Day09.advanced_decompress_length("(27x12)(20x12)(13x14)(7x10)(1x12)A")
  241920 # "A" * 241920

  iex> Day09.advanced_decompress_length("(25x3)(3x3)ABC(2x3)XY(5x2)PQRSTX(18x9)(3x2)TWO(5x7)SEVEN")
  445
  """
  def advanced_decompress_length(string) do
    case String.split(string, "(", parts: 2) do
      [string] ->
        String.length(string)

      [content, string] ->
        String.length(content) + length_via_marker_duplication(string)
    end
  end

  defp length_via_marker_duplication(string) do
    case String.split(string, ")", parts: 2) do
      [string] ->
        String.length(string)

      [marker, string] ->
        [dup_length, dup_count] = decode_marker(marker)

        {content_to_dup, rest} = String.split_at(string, dup_length)

        (String.duplicate(content_to_dup, dup_count) <> rest)
        |> advanced_decompress_length
    end
  end

  defp duplicate_via_marker(string) do
    case String.split(string, ")", parts: 2) do
      [string] ->
        string

      [marker, string] ->
        [dup_length, dup_count] = decode_marker(marker)

        {content_to_dup, rest} = String.split_at(string, dup_length)
        String.duplicate(content_to_dup, dup_count) <> decompress(rest)
    end
  end

  defp decode_marker(marker), do: String.split(marker, "x") |> Enum.map(&String.to_integer/1)

  def part1_verify, do: input() |> decompress() |> String.length()
end
