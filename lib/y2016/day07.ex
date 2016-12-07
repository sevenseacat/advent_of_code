defmodule Y2016.Day07 do
  use Advent.Day, no: 7

  import Integer, only: [is_odd: 1]

  def tls_addresses(input) do
    input
    |> Stream.reject(&(!tls_address?(&1)))
    |> Enum.count()
  end

  def parse_input do
    input() |> String.split()
  end

  @doc """
  iex> Day07.tls_address?("abba[mnop]qrst")
  true

  iex> Day07.tls_address?("abcd[bddb]xyyx")
  false

  iex> Day07.tls_address?("aaaa[qwer]tyui")
  false

  iex> Day07.tls_address?("ioxxoj[asdfgh]zxcvbn")
  true

  This wasn't part of the examples, but some of the input has multiple [] blocks
  which choked my first attempt at a solution.
  iex> Day07.tls_address?("ioxxoj[asdfgh]zxcvbn[asdfgh]zxcvbn")
  true
  """
  def tls_address?(address) do
    address
    |> String.split(["[", "]"])
    |> check_tls_address(0, false)
  end

  def check_tls_address([], _position, truthy), do: truthy

  def check_tls_address([head | tail], position, truthy) do
    abba = ~r/(\w)((?!\1)\w)\2\1/

    case String.match?(head, abba) do
      true ->
        case is_odd(position) do
          true -> false
          false -> check_tls_address(tail, position + 1, true)
        end

      false ->
        check_tls_address(tail, position + 1, truthy)
    end
  end

  def part1_verify, do: parse_input() |> tls_addresses()
end
