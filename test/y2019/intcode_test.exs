defmodule Y2019.IntcodeTest do
  use ExUnit.Case
  alias Y2019.Intcode

  describe "run/1" do
    test "basic input 1 from day 2" do
      %Intcode{program: program} = Intcode.new(to_array([1, 0, 0, 0, 99])) |> Intcode.run()
      assert [2, 0, 0, 0, 99] == from_array(program)
    end

    test "basic input 2 from day 2" do
      %Intcode{program: program} = Intcode.new(to_array([2, 3, 0, 3, 99])) |> Intcode.run()
      assert [2, 3, 0, 6, 99] == from_array(program)
    end

    test "basic input 3 from day 2" do
      %Intcode{program: program} = Intcode.new(to_array([2, 4, 4, 5, 99, 0])) |> Intcode.run()
      assert [2, 4, 4, 5, 99, 9801] == from_array(program)
    end

    test "basic input 4 from day 2" do
      %Intcode{program: program} =
        Intcode.new(to_array([1, 1, 1, 4, 99, 5, 6, 0, 99])) |> Intcode.run()

      assert [30, 1, 1, 4, 2, 5, 6, 0, 99] == from_array(program)
    end

    test "an input that has an output" do
      %Intcode{program: program, outputs: outputs} =
        Intcode.new(to_array([3, 0, 4, 0, 99]), [444]) |> Intcode.run()

      assert [444, 0, 4, 0, 99] == from_array(program)
      assert [444] == outputs
    end

    test "an input with modes" do
      %Intcode{program: program} = Intcode.new(to_array([1002, 4, 3, 4, 33])) |> Intcode.run()
      assert [1002, 4, 3, 4, 99] == from_array(program)
    end

    test "jump test #1 - position mode" do
      %Intcode{outputs: [output]} =
        Intcode.new(
          to_array([3, 12, 6, 12, 15, 1, 13, 14, 13, 4, 13, 99, -1, 0, 1, 9]),
          [0]
        )
        |> Intcode.run()

      assert output == 0
    end

    test "jump test #2 - position mode" do
      %Intcode{outputs: [output]} =
        Intcode.new(
          to_array([3, 12, 6, 12, 15, 1, 13, 14, 13, 4, 13, 99, -1, 0, 1, 9]),
          [42]
        )
        |> Intcode.run()

      assert output == 1
    end

    test "jump test #1 - immediate mode" do
      %Intcode{outputs: [output]} =
        Intcode.new(to_array([3, 3, 1105, -1, 9, 1101, 0, 0, 12, 4, 12, 99, 1]), [
          0
        ])
        |> Intcode.run()

      assert output == 0
    end

    test "jump test #2 - immediate mode" do
      %Intcode{outputs: [output]} =
        Intcode.new(to_array([3, 3, 1105, -1, 9, 1101, 0, 0, 12, 4, 12, 99, 1]), [
          42
        ])
        |> Intcode.run()

      assert output == 1
    end

    test "equal test #1 - is equal to 8" do
      %Intcode{outputs: [output]} =
        Intcode.new(to_array([3, 9, 8, 9, 10, 9, 4, 9, 99, -1, 8]), [8]) |> Intcode.run()

      assert output == 1
    end

    test "equal test #1 - is not equal to 8" do
      %Intcode{outputs: [output]} =
        Intcode.new(to_array([3, 9, 8, 9, 10, 9, 4, 9, 99, -1, 8]), [33]) |> Intcode.run()

      assert output == 0
    end

    test "less than test #1 - is less than 8" do
      %Intcode{outputs: [output]} =
        Intcode.new(to_array([3, 9, 7, 9, 10, 9, 4, 9, 99, -1, 8]), [2]) |> Intcode.run()

      assert output == 1
    end

    test "less than test #1 - is not less than 8" do
      %Intcode{outputs: [output]} =
        Intcode.new(to_array([3, 9, 7, 9, 10, 9, 4, 9, 99, -1, 8]), [8]) |> Intcode.run()

      assert output == 0
    end

    test "equal test #2 - is equal to 8" do
      %Intcode{outputs: [output]} =
        Intcode.new(to_array([3, 3, 1108, -1, 8, 3, 4, 3, 99]), [8]) |> Intcode.run()

      assert output == 1
    end

    test "equal test #2 - is not equal to 8" do
      %Intcode{outputs: [output]} =
        Intcode.new(to_array([3, 3, 1108, -1, 8, 3, 4, 3, 99]), [1]) |> Intcode.run()

      assert output == 0
    end

    test "less than test #2 - is less than 8" do
      %Intcode{outputs: [output]} =
        Intcode.new(to_array([3, 3, 1107, -1, 8, 3, 4, 3, 99]), [2]) |> Intcode.run()

      assert output == 1
    end

    test "less than test #2 - is not less than 8" do
      %Intcode{outputs: [output]} =
        Intcode.new(to_array([3, 3, 1107, -1, 8, 3, 4, 3, 99]), [8]) |> Intcode.run()

      assert output == 0
    end

    test "relative sample #1 (day 9)" do
      input = [109, 1, 204, -1, 1001, 100, 1, 100, 1008, 100, 16, 101, 1006, 101, 0, 99]
      outputs = Intcode.new(to_array(input), []) |> Intcode.run() |> Intcode.outputs()

      assert outputs == input
    end

    test "relative sample #2 (day 9)" do
      %Intcode{outputs: [output]} =
        Intcode.new(to_array([1102, 34_915_192, 34_915_192, 7, 4, 7, 99, 0])) |> Intcode.run()

      assert 16 == String.length(Integer.to_string(output))
    end

    test "relative sample #3 (day 9)" do
      %Intcode{outputs: outputs} =
        Intcode.new(to_array([104, 1_125_899_906_842_624, 99])) |> Intcode.run()

      assert outputs == [1_125_899_906_842_624]
    end
  end

  def to_array(list), do: :array.from_list(list, 0)
  def from_array(array), do: :array.to_list(array)
end
