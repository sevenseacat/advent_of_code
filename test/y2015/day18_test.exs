defmodule Y2015.Day18Test do
  use ExUnit.Case, async: true
  alias Y2015.Day18
  doctest Day18

  test "verification, part 1", do: assert(Day18.part1_verify() == 768)

  test "parse_input/1" do
    input = ".#.#.#\n...##.\n#....#\n..#...\n#.#..#\n####.."

    expected = %{
      {0, 0} => :off,
      {0, 1} => :on,
      {0, 2} => :off,
      {0, 3} => :on,
      {0, 4} => :off,
      {0, 5} => :on,
      {1, 0} => :off,
      {1, 1} => :off,
      {1, 2} => :off,
      {1, 3} => :on,
      {1, 4} => :on,
      {1, 5} => :off,
      {2, 0} => :on,
      {2, 1} => :off,
      {2, 2} => :off,
      {2, 3} => :off,
      {2, 4} => :off,
      {2, 5} => :on,
      {3, 0} => :off,
      {3, 1} => :off,
      {3, 2} => :on,
      {3, 3} => :off,
      {3, 4} => :off,
      {3, 5} => :off,
      {4, 0} => :on,
      {4, 1} => :off,
      {4, 2} => :on,
      {4, 3} => :off,
      {4, 4} => :off,
      {4, 5} => :on,
      {5, 0} => :on,
      {5, 1} => :on,
      {5, 2} => :on,
      {5, 3} => :on,
      {5, 4} => :off,
      {5, 5} => :off
    }

    assert Day18.parse_input(input) == expected
  end

  test "format_output/1" do
    input = %{
      {0, 0} => :off,
      {0, 1} => :on,
      {0, 2} => :off,
      {0, 3} => :on,
      {0, 4} => :off,
      {0, 5} => :on,
      {1, 0} => :off,
      {1, 1} => :off,
      {1, 2} => :off,
      {1, 3} => :on,
      {1, 4} => :on,
      {1, 5} => :off,
      {2, 0} => :on,
      {2, 1} => :off,
      {2, 2} => :off,
      {2, 3} => :off,
      {2, 4} => :off,
      {2, 5} => :on,
      {3, 0} => :off,
      {3, 1} => :off,
      {3, 2} => :on,
      {3, 3} => :off,
      {3, 4} => :off,
      {3, 5} => :off,
      {4, 0} => :on,
      {4, 1} => :off,
      {4, 2} => :on,
      {4, 3} => :off,
      {4, 4} => :off,
      {4, 5} => :on,
      {5, 0} => :on,
      {5, 1} => :on,
      {5, 2} => :on,
      {5, 3} => :on,
      {5, 4} => :off,
      {5, 5} => :off
    }

    expected = ".#.#.#\n...##.\n#....#\n..#...\n#.#..#\n####.."

    assert Day18.format_output(input) == expected
  end

  test "running loops, part 1" do
    parsed_input = Day18.parse_input(".#.#.#\n...##.\n#....#\n..#...\n#.#..#\n####..")
    c = & &1
    step1 = "..##..\n..##.#\n...##.\n......\n#.....\n#.##.."
    step2 = "..###.\n......\n..###.\n......\n.#....\n.#...."
    step3 = "...#..\n......\n...#..\n..##..\n......\n......"
    step4 = "......\n......\n..##..\n..##..\n......\n......"

    assert parsed_input |> Day18.loop(1, c) |> Day18.format_output() == step1
    assert parsed_input |> Day18.loop(2, c) |> Day18.format_output() == step2
    assert parsed_input |> Day18.loop(3, c) |> Day18.format_output() == step3
    assert parsed_input |> Day18.loop(4, c) |> Day18.format_output() == step4
  end
end
