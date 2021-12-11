defmodule Y2021.Day11Test do
  use ExUnit.Case, async: true
  alias Y2021.Day11
  doctest Day11

  test "verification, part 1", do: assert(Day11.part1_verify() == 1675)
  test "verification, part 2", do: assert(Day11.part2_verify() == 515)

  describe "part1/1" do
    test "small input" do
      result =
        "11111\n19991\n19191\n19991\n11111"
        |> Day11.parse_input()
        |> Day11.part1(1)

      assert result == 9
    end

    test "large input" do
      input =
        Day11.parse_input(
          "5483143223\n2745854711\n5264556173\n6141336146\n6357385478\n4167524645\n2176841721\n6882881134\n4846848554\n5283751526"
        )

      assert Day11.part1(input, 10) == 204
      assert Day11.part1(input, 100) == 1656
    end
  end

  describe "part2/1" do
    test "large input" do
      input =
        Day11.parse_input(
          "5483143223\n2745854711\n5264556173\n6141336146\n6357385478\n4167524645\n2176841721\n6882881134\n4846848554\n5283751526"
        )

      assert Day11.part2(input) == 195
    end
  end

  describe "run_steps/2" do
    test "small input" do
      initial = Day11.parse_input("11111\n19991\n19191\n19991\n11111")
      step1 = Day11.parse_input("34543\n40004\n50005\n40004\n34543")
      step2 = Day11.parse_input("45654\n51115\n61116\n51115\n45654")

      assert Day11.run_steps(initial, 1, 0) == {step1, 9}
      assert Day11.run_steps(initial, 2, 0) == {step2, 9}
    end

    test "large input" do
      data_map = [
        {0,
         "5483143223\n2745854711\n5264556173\n6141336146\n6357385478\n4167524645\n2176841721\n6882881134\n4846848554\n5283751526"},
        {1,
         "6594254334\n3856965822\n6375667284\n7252447257\n7468496589\n5278635756\n3287952832\n7993992245\n5957959665\n6394862637"},
        {2,
         "8807476555\n5089087054\n8597889608\n8485769600\n8700908800\n6600088989\n6800005943\n0000007456\n9000000876\n8700006848"},
        {3,
         "0050900866\n8500800575\n9900000039\n9700000041\n9935080063\n7712300000\n7911250009\n2211130000\n0421125000\n0021119000"},
        {4,
         "2263031977\n0923031697\n0032221150\n0041111163\n0076191174\n0053411122\n0042361120\n5532241122\n1532247211\n1132230211"},
        {5,
         "4484144000\n2044144000\n2253333493\n1152333274\n1187303285\n1164633233\n1153472231\n6643352233\n2643358322\n2243341322"},
        {6,
         "5595255111\n3155255222\n3364444605\n2263444496\n2298414396\n2275744344\n2264583342\n7754463344\n3754469433\n3354452433"},
        {7,
         "6707366222\n4377366333\n4475555827\n3496655709\n3500625609\n3509955566\n3486694453\n8865585555\n4865580644\n4465574644"},
        {8,
         "7818477333\n5488477444\n5697666949\n4608766830\n4734946730\n4740097688\n6900007564\n0000009666\n8000004755\n6800007755"},
        {9,
         "9060000644\n7800000976\n6900000080\n5840000082\n5858000093\n6962400000\n8021250009\n2221130009\n9111128097\n7911119976"}
      ]

      data_map
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.map(fn [{num1, str1}, {num2, str2}] ->
        data1 = Day11.parse_input(str1)
        data2 = Day11.parse_input(str2)

        next = Day11.run_steps(data1, num2 - num1, 0) |> elem(0)
        assert next == data2
      end)
    end
  end
end
