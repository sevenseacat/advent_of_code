defmodule Y2022.Day25 do
  use Advent.Day, no: 25

  # 34561628468940 not right
  def part1(input) do
    Enum.sum(input)
    |> to_snafu()
  end

  defp to_snafu(num) do
    mapping = %{-2 => "=", -1 => "-"}

    num
    |> Integer.digits(5)
    |> Enum.reverse()
    |> convert_digits()
    |> Enum.reverse()
    |> Enum.map(&Map.get(mapping, &1, &1))
    |> Enum.join("")
  end

  defp convert_digits([a]) when a in 0..2, do: [a]
  defp convert_digits([a]), do: [-5 + a, -1]

  defp convert_digits([a, b | rest]) do
    case a do
      val when val in 0..2 -> [val | convert_digits([b | rest])]
      val -> [-5 + val | convert_digits([b + 1 | rest])]
    end
  end

  def parse_input(input) do
    mapping = %{"=" => -2, "-" => -1, "0" => 0, "1" => 1, "2" => 2}

    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn row ->
      row
      |> String.graphemes()
      |> Enum.map(&Map.get(mapping, &1))
      |> Integer.undigits(5)
    end)
  end

  def part1_verify, do: input() |> parse_input() |> part1()
end
