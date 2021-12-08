defmodule Y2021.Day08 do
  use Advent.Day, no: 8

  def part1(input) do
    input
    |> Enum.map(&find_output_value/1)
    |> List.flatten()
    |> Enum.filter(fn k -> Enum.member?([1, 4, 7, 8], k) end)
    |> length
  end

  def part2(input) do
    input
    |> Enum.map(&find_output_value/1)
    |> Enum.map(&output_to_number/1)
    |> Enum.sum()
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
    signals = Enum.map(signals, fn s -> String.graphemes(s) end)

    # The easy ones for part 1
    one = Enum.find(signals, fn s -> length(s) == 2 end)
    seven = Enum.find(signals, fn s -> length(s) == 3 end)
    four = Enum.find(signals, fn s -> length(s) == 4 end)
    eight = Enum.find(signals, fn s -> length(s) == 7 end)
    six_nine_zero = Enum.filter(signals, fn s -> length(s) == 6 end)
    two_three_five = Enum.filter(signals, fn s -> length(s) == 5 end)

    #    ZZZZ    Comments below refer to segments as labelled in that diagram
    #   X    Y   <------
    #   X    Y
    #    VVVV
    #   W    T
    #   W    T
    #    SSSS

    # segments T and Y make up number 1.
    # segment Z is the difference between 1 and 7.
    seg_z = hd(seven -- one)

    # the difference between 4 and 1 are segments X and V.
    segs_xv = four -- one

    # one of those two is in all of 6, 9, and 0 (segment X) - the other is segment V.
    seg_x =
      Enum.find(segs_xv, fn xv ->
        Enum.all?(six_nine_zero, fn snz ->
          Enum.member?(snz, xv)
        end)
      end)

    seg_v = hd(segs_xv -- [seg_x])

    # 9 is the only signal that has all of Z, X, V, Y and T and one other.
    segs_for_nine = [seg_x, seg_v, seg_z | one]
    nine = Enum.find(six_nine_zero, fn snz -> length(snz -- segs_for_nine) == 1 end)
    # that one other is segment S.
    seg_s = hd(nine -- segs_for_nine)

    # 3 has Z, X, S, T and Y.
    segs_for_three = [seg_z, seg_v, seg_s | one]
    three = Enum.find(two_three_five, fn ttf -> length(ttf -- segs_for_three) == 0 end)

    # 0 is 8 minus segment V.
    zero = Enum.find(six_nine_zero, fn snz -> snz == eight -- [seg_v] end)

    # we know nine and zero, so six is the other six-segment signal.
    six = hd(six_nine_zero -- [nine, zero])

    # now we're just missing knowing which of T and Y is which.
    # these make up 2 and 5.
    two_five = two_three_five -- [three]
    # and T but we don't know that yet
    segs_for_five = [seg_z, seg_x, seg_v, seg_s]
    five = Enum.find(two_five, fn tf -> length(tf -- segs_for_five) == 1 end)
    two = hd(two_five -- [five])

    [
      {one, 1},
      {two, 2},
      {three, 3},
      {four, 4},
      {five, 5},
      {six, 6},
      {seven, 7},
      {eight, 8},
      {nine, 9},
      {zero, 0}
    ]
    |> Enum.map(fn {k, v} -> {List.to_string(k), v} end)
    |> Enum.into(%{})
  end

  defp output_to_number(list) do
    list
    |> Enum.join()
    |> String.to_integer()
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
  def part2_verify, do: input() |> parse_input() |> part2()
end
