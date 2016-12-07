defmodule Y2016.Day07 do
  use Advent.Day, no: 7

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

  Some more examples to flesh out edge cases that the original tests didn't cover.
  iex> Day07.tls_address?("ioxxoj[asdfgh]zxcvbn[asdfgh]zxcvbn")
  true

  iex> Day07.tls_address?("ioxxoj[abcoxxoabc]zxcvbn[asdfgh]zxcvbn")
  false
  """
  def tls_address?(address) do
    abba = "(\\w)((?!\\1)\\w)\\2\\1"

    case String.match?(address, ~r/\[\w*#{abba}\w*\]/) do
      # If there is an ABBA in the hypernet [] parts, it's all over.
      true -> false
      # But if not, and there's an ABBA anywhere in the string, it's a win.
      false -> String.match?(address, ~r/#{abba}/)
    end
  end

  def part1_verify, do: parse_input() |> tls_addresses()
end
