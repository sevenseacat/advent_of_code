defmodule Y2016.Day04 do
  use Advent.Day, no: 4

  def real_room_sector_sum do
    parse_input()
    |> Stream.map(&parse_room_details/1)
    |> Stream.reject(&(!real_room?(&1)))
    |> Stream.map(& &1["sector"])
    |> Enum.sum()
  end

  def parse_input do
    input() |> String.split()
  end

  @doc """
  iex> Day04.parse_room_details("aaaaa-bbb-z-y-x-123[abxyz]")
  %{"name" => "aaaaabbbzyx", "sector" => 123, "checksum" => "abxyz",
    "letter_frequency" => [a: 5, b: 3, x: 1, y: 1, z: 1]}

  iex> Day04.parse_room_details("a-b-c-d-e-f-g-h-987[abcde]")
  %{"name" => "abcdefgh", "sector" => 987, "checksum" => "abcde",
    "letter_frequency" => [a: 1, b: 1, c: 1, d: 1, e: 1, f: 1, g: 1, h: 1]}

  iex> Day04.parse_room_details("not-a-real-room-404[oarel]")
  %{"name" => "notarealroom", "sector" => 404, "checksum" => "oarel",
    "letter_frequency" => [a: 2, e: 1, l: 1, m: 1, n: 1, o: 3, r: 2, t: 1]}

  iex> Day04.parse_room_details("totally-real-room-200[decoy]")
  %{"name" => "totallyrealroom", "sector" => 200, "checksum" => "decoy",
    "letter_frequency" => [a: 2, e: 1, l: 3, m: 1, o: 3, r: 2, t: 2, y: 1]}
  """
  def parse_room_details(room) do
    short_room =
      room
      |> String.replace("-", "")

    details =
      Regex.named_captures(
        ~r/^(?P<name>[a-z]+)(?P<sector>\d+)\[(?P<checksum>[a-z]+)\]$/,
        short_room
      )

    details
    |> Map.put("sector", String.to_integer(details["sector"]))
    |> Map.put("letter_frequency", letter_frequency(details["name"]))
  end

  defp letter_frequency(name) do
    name
    |> String.to_charlist()
    |> Enum.sort()
    |> Enum.chunk_by(& &1)
    |> Enum.map(fn letters -> {List.to_atom([List.first(letters)]), length(letters)} end)
  end

  @doc """
  iex> Day04.real_room?(%{"checksum" => "oarel",
  ...> "letter_frequency" => [a: 2, e: 1, l: 1, m: 1, n: 1, o: 3, r: 2, t: 1]})
  true

  iex> Day04.real_room?(%{"checksum" => "decoy",
  ...> "letter_frequency" => [a: 2, e: 1, l: 3, m: 1, o: 3, r: 2, t: 2, y: 1]})
  false
  """
  def real_room?(room) do
    calculated_checksum =
      room["letter_frequency"]
      |> Enum.sort(fn {_, first}, {_, second} -> first >= second end)
      |> Keyword.keys()
      |> Enum.take(5)
      |> Enum.map(&to_string/1)
      |> to_string

    calculated_checksum == room["checksum"]
  end

  def part1_verify, do: real_room_sector_sum()
end
