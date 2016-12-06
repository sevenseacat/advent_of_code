defmodule Y2016.Day05 do
  use Advent.Day, no: 5

  @input "uqwqemis"

  @doc """
  iex> Day05.basic_password("abc")
  "18F47A30"
  """
  def basic_password(input \\ @input) do
    brute_force(input, 0, "")
  end

  defp brute_force(_input, _counter, <<password::binary-size(8)>>), do: String.reverse(password)

  defp brute_force(input, counter, password) do
    password =
      case :crypto.hash(:md5, "#{input}#{counter}") |> Base.encode16() do
        <<"00000", rest::binary>> -> String.first(rest) <> password
        _ -> password
      end

    brute_force(input, counter + 1, password)
  end

  def part1_verify, do: basic_password(@input)
end
