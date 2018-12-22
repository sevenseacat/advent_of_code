defmodule Y2018.Day20Test do
  use ExUnit.Case, async: true
  alias Y2018.Day20
  doctest Day20

  describe "generate_all_paths" do
    test "no branching" do
      actual = Day20.generate_all_paths(String.graphemes("WNE$")) |> Enum.sort()
      expected = ["WNE"] |> Enum.map(&String.graphemes/1)

      assert expected == actual
    end

    test "one branch" do
      actual = Day20.generate_all_paths(String.graphemes("WN(E|W|)S$")) |> Enum.sort()
      expected = ["WNES", "WNS", "WNWS"] |> Enum.map(&String.graphemes/1)

      assert expected == actual
    end

    test "multiple branches" do
      actual = Day20.generate_all_paths(String.graphemes("WN(E|W)AB(SS|W)$")) |> Enum.sort()
      expected = ["WNEABSS", "WNEABW", "WNWABSS", "WNWABW"] |> Enum.map(&String.graphemes/1)

      assert expected == actual
    end

    test "nested branches" do
      actual = Day20.generate_all_paths(String.graphemes("W(NSS|ENE(A|BW)|)QQ$")) |> Enum.sort()

      expected =
        ["WENEAQQ", "WENEBWQQ", "WENEQQ", "WNSSQQ", "WQQ"] |> Enum.map(&String.graphemes/1)

      assert expected == actual
    end
  end
end
