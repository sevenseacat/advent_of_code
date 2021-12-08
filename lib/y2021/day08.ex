defmodule Y2021.Day08 do
  use Advent.Day, no: 8

  def part1(input) do
    input
    |> Enum.map(&find_output_value/1)
    |> List.flatten()
    |> Enum.filter(fn k -> Enum.member?([1, 4, 7, 8], k) end)
    |> length
  end

  def find_output_value(%{signals: signals, outputs: outputs}) do
    signals
    |> find_digits()
    |> convert_output_value(outputs)
  end

  defp convert_output_value(digits, outputs) do
    Enum.map(outputs, fn output -> Map.get(digits, output) end)
  end

  def find_digits(signals) do
    # The easy ones for part 1
    one = Enum.find(signals, fn s -> String.length(s) == 2 end)
    seven = Enum.find(signals, fn s -> String.length(s) == 3 end)
    four = Enum.find(signals, fn s -> String.length(s) == 4 end)
    eight = Enum.find(signals, fn s -> String.length(s) == 7 end)

    # The rest will go here

    %{one => 1, seven => 7, four => 4, eight => 8}
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn row ->
      [signals, outputs] =
        row
        |> String.split(" | ", parts: 2)
        |> Enum.map(fn section ->
          section
          |> String.split(" ")
          |> Enum.map(fn word ->
            word |> String.graphemes() |> Enum.sort() |> List.to_string()
          end)
        end)

      %{signals: signals, outputs: outputs}
    end)
  end

  def part1_verify, do: input() |> parse_input() |> part1()
end
