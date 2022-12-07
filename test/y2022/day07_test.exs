defmodule Y2022.Day07Test do
  use ExUnit.Case, async: true
  alias Y2022.Day07
  doctest Day07

  @parsed_sample_input %{
    "a" => %{
      "e" => %{
        "i" => 584
      },
      "f" => 29116,
      "g" => 2557,
      "h.lst" => 62596
    },
    "b.txt" => 14_848_514,
    "c.dat" => 8_504_156,
    "d" => %{
      "j" => 4_060_174,
      "d.log" => 8_033_020,
      "d.ext" => 5_626_152,
      "k" => 7_214_296
    }
  }
  test "verification, part 1", do: assert(Day07.part1_verify() == 1_367_870)
  test "verification, part 2", do: assert(Day07.part2_verify() == 549_173)

  test "part1/1" do
    assert Day07.part1(@parsed_sample_input) == 95437
  end

  test "part2/1" do
    assert Day07.part2(@parsed_sample_input) == 24_933_642
  end

  test "parse_input/1" do
    input = """
    $ cd /
    $ ls
    dir a
    14848514 b.txt
    8504156 c.dat
    dir d
    $ cd a
    $ ls
    dir e
    29116 f
    2557 g
    62596 h.lst
    $ cd e
    $ ls
    584 i
    $ cd ..
    $ cd ..
    $ cd d
    $ ls
    4060174 j
    8033020 d.log
    5626152 d.ext
    7214296 k
    """

    output = %{
      "a" => %{
        "e" => %{
          "i" => 584
        },
        "f" => 29116,
        "g" => 2557,
        "h.lst" => 62596
      },
      "b.txt" => 14_848_514,
      "c.dat" => 8_504_156,
      "d" => %{
        "j" => 4_060_174,
        "d.log" => 8_033_020,
        "d.ext" => 5_626_152,
        "k" => 7_214_296
      }
    }

    assert Day07.parse_input(input) == output
  end
end
