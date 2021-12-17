defmodule Y2021.Day16 do
  use Advent.Day, no: 16

  import Bitwise

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
    |> get_version()
  end

  @doc """
  iex> Day16.part2("C200B40A82")
  3

  iex> Day16.part2("04005AC33890")
  54

  iex> Day16.part2("880086C3E88112")
  7

  iex> Day16.part2("CE00C43D881120")
  9

  iex> Day16.part2("D8005AC2A8F0")
  1

  iex> Day16.part2("F600BC2D8F")
  0

  iex> Day16.part2("9C005AC2F8F0")
  0

  iex> Day16.part2("9C0141080250320F1802104A08")
  1
  """
  def part2(string) do
    string
    |> parse_input
    |> get_value
  end

  defp get_version(%{version: version, subpackets: subpackets}) do
    version + Enum.reduce(subpackets, 0, fn packet, acc -> acc + get_version(packet) end)
  end

  defp get_version(%{version: version}), do: version

  defp get_value(%{type_id: 4, value: value}), do: value

  defp get_value(%{type_id: type_id, subpackets: subpackets}) do
    values = Enum.map(subpackets, &get_value/1)

    case type_id do
      0 -> Enum.sum(values)
      1 -> Enum.product(values)
      2 -> Enum.min(values)
      3 -> Enum.max(values)
      5 -> greater_than?(values)
      6 -> greater_than?(Enum.reverse(values))
      7 -> equal?(values)
    end
  end

  defp greater_than?([val1, val2]), do: if(val1 > val2, do: 1, else: 0)

  defp equal?([val1, val2]), do: if(val1 == val2, do: 1, else: 0)

  @doc """
  iex> Day16.parse_input("D2FE28")
  %{version: 6, type_id: 4, value: 2021}

  iex> Day16.parse_input("38006F45291200")
  %{version: 1, type_id: 6, subpackets: [%{type_id: 4, value: 10, version: 6}, %{type_id: 4, value: 20, version: 2}]}

  iex> Day16.parse_input("EE00D40C823060")
  %{version: 7, type_id: 3, subpackets: [
    %{type_id: 4, value: 1, version: 2}, %{type_id: 4, value: 2, version: 4}, %{type_id: 4, value: 3, version: 1}
  ]}
  """
  def parse_input(string) do
    string
    |> String.trim()
    |> Base.decode16!()
    |> parse_packet()
    |> elem(0)
  end

  defp parse_packet(<<version::3, 4::3, rest::bits>>) do
    {literal, rest} = parse_literal(rest, 0)
    {%{version: version, type_id: 4, value: literal}, rest}
  end

  defp parse_packet(<<version::3, type::3, rest::bits>>) do
    {subpackets, rest} = parse_subpackets(rest)
    {%{version: version, type_id: type, subpackets: subpackets}, rest}
  end

  # The extra zeros at the end. Ignore.
  defp parse_packet(_) do
    {[], nil}
  end

  defp parse_packets(bits) do
    {packet, rest} = parse_packet(bits)

    case packet do
      [] ->
        {[], rest}

      packet ->
        {packets, rest} = parse_packets(rest)
        {[packet | packets], rest}
    end
  end

  defp parse_subpackets(<<0::1, length::15, subpackets::bits-size(length), rest::bits>>) do
    {parse_packets(subpackets) |> elem(0), rest}
  end

  defp parse_subpackets(<<1::1, count::11, rest::bits>>) do
    {packets, rest} =
      1..count
      |> Enum.reduce({[], rest}, fn _, {packets, rest} ->
        {packet, rest} = parse_packet(rest)
        {[packet | packets], rest}
      end)

    {Enum.reverse(packets), rest}
  end

  defp parse_literal(<<0::1, value::4, rest::bits>>, acc) do
    {(acc <<< 4) + value, rest}
  end

  defp parse_literal(<<1::1, value::4, rest::bits>>, acc) do
    parse_literal(rest, (acc <<< 4) + value)
  end

  def part1_verify, do: input() |> part1()
  def part2_verify, do: input() |> part2()
end
