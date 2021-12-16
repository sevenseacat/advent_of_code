defmodule Y2021.Day16 do
  use Advent.Day, no: 16

  @doc """
  iex> Day16.part1(:parsed_input)
  :ok
  """
  def part1(_input) do
    :ok
  end

  @doc """
  iex> Day16.parse_input("D2FE28")
  [%{version: 6, type_id: 4, value: 2021}]
  """
  def parse_input(string) do
    string
    |> String.trim()
    |> Base.decode16!()
    |> parse_packets()
  end

  defp parse_packets(<<>>), do: []

  defp parse_packets(<<version::3, 4::3, rest::bits>>) do
    {literal, rest} = parse_literal(rest, 6)
    number = literal |> pad_leading_zeros() |> :binary.decode_unsigned()
    [%{version: version, type_id: 4, value: number} | parse_packets(rest)]
  end

  # Ignore trailing zeros
  defp parse_literal(<<0::1, value::bits-4, rest::bits>>, size) do
    {value, parse_literal(rest, size + 5)}
  end

  defp parse_literal(<<1::1, value::bits-4, rest::bits>>, size) do
    {next, rest} = parse_literal(rest, size + 5)
    {<<value::bitstring, next::bitstring>>, rest}
  end

  defp parse_literal(<<rest::bits>>, size) do
    trailing_zeros = 4 - rem(size, 4)
    <<0::size(trailing_zeros), rest::bits>> = rest
    rest
  end

  # Turn a value <<126, 5::size(4)>> like into a number
  # https://elixirforum.com/t/how-to-manipurate-bitstring-not-binary-such-as-making-a-value-concatinating-converting-into-integer/22654/4
  defp pad_leading_zeros(bs) when is_binary(bs), do: bs

  defp pad_leading_zeros(bs) when is_bitstring(bs) do
    pad_length = 8 - rem(bit_size(bs), 8)
    <<0::size(pad_length), bs::bitstring>>
  end

  def part1_verify, do: input() |> part1()
end
