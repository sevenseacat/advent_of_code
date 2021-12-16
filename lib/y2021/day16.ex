defmodule Y2021.Day16 do
  use Advent.Day, no: 16

  @doc """
  iex> Day16.part1("D2FE28")
  6

  iex> Day16.part1("8A004A801A8002F478")
  16

  iex> Day16.part1("620080001611562C8802118E34")
  12

  iex> Day16.part1("C0015000016115A2E0802F182340")
  23

  iex> Day16.part1("A0016C880162017C3686B18A3D4780")
  31
  """
  def part1(string) do
    string
    |> parse_input
    |> hd
    |> get_version()
  end

  defp get_version(%{version: version, subpackets: subpackets}) do
    version + Enum.reduce(subpackets, 0, fn packet, acc -> acc + get_version(packet) end)
  end

  defp get_version(%{version: version}), do: version

  @doc """
  iex> Day16.parse_input("D2FE28")
  [%{version: 6, type_id: 4, value: 2021}]

  iex> Day16.parse_input("38006F45291200")
  [%{version: 1, type_id: 6, subpackets: [%{type_id: 4, value: 10, version: 6}, %{type_id: 4, value: 20, version: 2}]}]

  iex> Day16.parse_input("EE00D40C823060")
  [%{version: 7, type_id: 3, subpackets: [
    %{type_id: 4, value: 1, version: 2}, %{type_id: 4, value: 2, version: 4}, %{type_id: 4, value: 3, version: 1}
  ]}]
  """
  def parse_input(string) do
    string
    |> String.trim()
    |> Base.decode16!()
    |> parse_packets()
    |> elem(0)
  end

  defp parse_packet(<<version::3, 4::3, rest::bits>>) do
    {literal, rest} = parse_literal(rest)
    number = literal_list_to_number(literal)
    {%{version: version, type_id: 4, value: number}, rest} |> IO.inspect(label: "literal packet")
  end

  defp parse_packet(<<version::3, type::3, rest::bits>>) do
    {subpackets, rest} = parse_subpackets(rest) |> IO.inspect(label: "parsed subpackets")

    {%{version: version, type_id: type, subpackets: subpackets}, rest}
    |> IO.inspect(label: "operator packet")
  end

  defp parse_packet(val) do
    IO.inspect(val, label: "unknown packet data")
    {[], ""}
  end

  # All the trailing zeros that we can ignore/discard
  defp parse_packets(""), do: {[], ""}
  defp parse_packets(<<0::1>>), do: {[], ""}
  defp parse_packets(<<0::2>>), do: {[], ""}
  defp parse_packets(<<0::3>>), do: {[], ""}
  defp parse_packets(<<0::4>>), do: {[], ""}
  defp parse_packets(<<0::5>>), do: {[], ""}
  defp parse_packets(<<0::6>>), do: {[], ""}
  defp parse_packets(<<0::7>>), do: {[], ""}

  defp parse_packets(bits) do
    IO.inspect("looking for packets!")
    {packet, rest} = parse_packet(bits) |> IO.inspect(label: "packet")
    {packets, rest} = parse_packets(rest) |> IO.inspect(label: "packets")
    {[packet | packets], rest}
  end

  defp parse_subpackets(<<0::1, rest::bits>>) do
    <<subpacket_length::15, rest::bits>> = rest
    <<subpackets::bits-size(subpacket_length), rest::bits>> = rest
    {parse_packets(subpackets) |> elem(0), rest} |> IO.inspect(label: "subpackets by size")
  end

  defp parse_subpackets(<<1::1, rest::bits>>) do
    <<subpacket_count::11, rest::bits>> = rest

    {packets, rest} =
      1..subpacket_count
      |> Enum.reduce({[], rest}, fn _, {packets, rest} ->
        {packet, rest} = parse_packet(rest)
        {[packet | packets], rest}
      end)

    {Enum.reverse(packets), rest}
    |> IO.inspect(label: "subpackets by count")
  end

  # Ignore trailing zeros
  defp parse_literal(<<0::1, rest::bits>>) do
    <<value::4, rest::bits>> = rest
    {[value], rest}
  end

  defp parse_literal(<<1::1, value::4, rest::bits>>) do
    {next, rest} = parse_literal(rest)
    {[value | next], rest}
  end

  # Turn a list of numbers read from 4-bit chunks eg. [7, 14, 5] into their actual value -> 2021.
  defp literal_list_to_number(list), do: make_number(Enum.reverse(list), 0)

  defp make_number([], _), do: 0

  defp make_number([num | nums], power),
    do: num * Integer.pow(16, power) + make_number(nums, power + 1)

  def part1_verify, do: input() |> part1()
end
