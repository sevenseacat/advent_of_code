defmodule Y2016.Day05 do
  use Advent.Day, no: 5

  @input "uqwqemis"
  @password_length 8

  @doc """
  iex> Day05.basic_password("abc")
  "18F47A30"
  """
  def basic_password(input \\ @input) do
    brute_force(input, 0, "")
  end

  @doc """
  iex> Day05.complex_password("abc")
  "05ACE8E3"
  """
  def complex_password(input \\ @input) do
    complex_brute_force(input, 0, %{})
  end

  defp brute_force(_input, _counter, <<password::binary-size(@password_length)>>),
    do: String.reverse(password)

  defp brute_force(input, counter, password) do
    password =
      case :crypto.hash(:md5, "#{input}#{counter}") |> Base.encode16() do
        <<"00000", char::binary-size(1), _rest::binary>> -> char <> password
        _ -> password
      end

    brute_force(input, counter + 1, password)
  end

  defp complex_brute_force(_input, _counter, password)
       when map_size(password) == @password_length do
    password
    |> Enum.sort()
    |> Enum.map(fn {_pos, val} -> val end)
    |> to_string
  end

  defp complex_brute_force(input, counter, password) do
    password =
      case :crypto.hash(:md5, "#{input}#{counter}") |> Base.encode16() do
        <<"00000", position::binary-size(1), char::binary-size(1), _rest::binary>>
        when position <= "7" ->
          Map.put_new(password, position, char)

        _ ->
          password
      end

    complex_brute_force(input, counter + 1, password)
  end

  def part1_verify, do: basic_password(@input)
  def part2_verify, do: complex_password(@input)
end
