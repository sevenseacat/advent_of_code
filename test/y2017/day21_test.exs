defmodule Y2017.Day21Test do
  use ExUnit.Case, async: true
  alias Y2017.Day21
  alias Y2017.Day21.Rule
  doctest Day21

  test "verification, part 1", do: assert(Day21.part1_verify() == 186)
  test "verification, part 2", do: assert(Day21.part2_verify() == 3_018_423)

  describe "part1/2" do
    test "generates correct result for example provided" do
      assert Day21.part1("../.# => ##./#../...\n.#./..#/### => #..#/..../..../#..#", 2) == 12
    end
  end

  describe "disassemble/1" do
    test "can disassemble a grid into 2x2 chunks" do
      chunks = Day21.disassemble(["...#", "###.", "#.#.", ".###"])
      assert chunks == [["..", "##"], [".#", "#."], ["#.", ".#"], ["#.", "##"]]
    end

    test "can disassemble a grid into 3x3 chunks" do
      chunks =
        Day21.disassemble([
          ".........",
          "#########",
          ".#.#..##.",
          "##.##.##.",
          "#########",
          ".........",
          ".........",
          ".#.#..##.",
          "##.##.##."
        ])

      assert chunks == [
               ["...", "###", ".#."],
               ["...", "###", "#.."],
               ["...", "###", "##."],
               ["##.", "###", "..."],
               ["##.", "###", "..."],
               ["##.", "###", "..."],
               ["...", ".#.", "##."],
               ["...", "#..", "##."],
               ["...", "##.", "##."]
             ]
    end

    test "prefers 2x2 grids over 3x3 grids" do
      # A 6x6 grid could disassemble to either.
      chunks = Day21.disassemble(["......", "......", "......", "......", "......", "......"])
      assert hd(chunks) |> List.first() |> String.length() == 2
    end
  end

  describe "transform_chunks/2" do
    test "applies a primary transform" do
      rules = [%Rule{input: 1, output: 2}, %Rule{input: 3, output: 4}]
      assert Day21.transform_chunks([3], rules) == [4]
    end

    test "applies a secondary transform when no primary transform matches" do
      rules = [
        %Rule{input: 1, alternates: [5, 6], output: 2},
        %Rule{input: 3, alternates: [7, 8], output: 4}
      ]

      assert Day21.transform_chunks([7], rules) == [4]
    end

    test "gives priority to primary transforms" do
      rules = [
        %Rule{input: 1, alternates: [6, 7], output: 2},
        %Rule{input: 3, alternates: [1, 5], output: 4}
      ]

      assert Day21.transform_chunks([1], rules) == [2]
    end
  end

  describe "reassemble/1" do
    test "can reassemble a grid from 2x2 chunks" do
      grid = Day21.reassemble([["..", "##"], [".#", "#."], ["#.", ".#"], ["#.", "##"]])
      assert grid == ["...#", "###.", "#.#.", ".###"]
    end

    test "can reassemble a grid from 3x3 chunks" do
      grid =
        Day21.reassemble([
          ["...", "###", ".#."],
          ["...", "###", "#.."],
          ["...", "###", "##."],
          ["##.", "###", "..."],
          ["##.", "###", "..."],
          ["##.", "###", "..."],
          ["...", ".#.", "##."],
          ["...", "#..", "##."],
          ["...", "##.", "##."]
        ])

      assert grid == [
               ".........",
               "#########",
               ".#.#..##.",
               "##.##.##.",
               "#########",
               ".........",
               ".........",
               ".#.#..##.",
               "##.##.##."
             ]
    end

    test "example in problem" do
      grid =
        Day21.reassemble([
          ["##.", "#..", "..."],
          ["##.", "#..", "..."],
          ["##.", "#..", "..."],
          ["##.", "#..", "..."]
        ])

      assert grid == ["##.##.", "#..#..", "......", "##.##.", "#..#..", "......"]
    end
  end

  describe "parse_input/1" do
    test "generates correct result for example provided" do
      parsed_input = Day21.parse_input("../.# => ##./#../...\n.#./..#/### => #..#/..../..../#..#")

      assert parsed_input == [
               %Rule{
                 input: ["..", ".#"],
                 alternates: [["#.", ".."], [".#", ".."], ["..", "#."]],
                 output: ["##.", "#..", "..."]
               },
               %Rule{
                 input: [".#.", "..#", "###"],
                 alternates: [
                   ["###", "#..", ".#."],
                   ["###", "..#", ".#."],
                   ["##.", "#.#", "#.."],
                   ["#..", "#.#", "##."],
                   [".##", "#.#", "..#"],
                   [".#.", "#..", "###"],
                   ["..#", "#.#", ".##"]
                 ],
                 output: ["#..#", "....", "....", "#..#"]
               }
             ]
    end
  end
end
