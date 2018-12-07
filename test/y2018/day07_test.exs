defmodule Y2018.Day07Test do
  use ExUnit.Case, async: true
  alias Y2018.Day07
  doctest Day07

  test "verification, part 1", do: assert(Day07.part1_verify() == "JMQZELVYXTIGPHFNSOADKWBRUC")
  test "verification, part 2", do: assert(Day07.part2_verify() == 1133)

  describe "tick" do
    test "it performs the first tick with sample input" do
      result =
        Day07.tick(%{
          todo: %{
            "A" => ["C"],
            "B" => ["A"],
            "C" => [],
            "D" => ["A"],
            "E" => ["F", "D", "B"],
            "F" => ["C"]
          },
          workers: [%{doing: nil, wait: 0}, %{doing: nil, wait: 0}],
          time: 0,
          done: [],
          delay: 0
        })

      assert result == %{
               todo: %{
                 "A" => ["C"],
                 "B" => ["A"],
                 "D" => ["A"],
                 "E" => ["F", "D", "B"],
                 "F" => ["C"]
               },
               workers: [%{doing: "C", wait: 3}, %{doing: nil, wait: 0}],
               time: 1,
               done: [],
               delay: 0
             }
    end

    test "it performs the second tick with sample input" do
      result =
        Day07.tick(%{
          todo: %{
            "A" => ["C"],
            "B" => ["A"],
            "D" => ["A"],
            "E" => ["F", "D", "B"],
            "F" => ["C"]
          },
          workers: [%{doing: "C", wait: 3}, %{doing: nil, wait: 0}],
          time: 1,
          done: [],
          delay: 0
        })

      assert result == %{
               todo: %{
                 "A" => ["C"],
                 "B" => ["A"],
                 "D" => ["A"],
                 "E" => ["F", "D", "B"],
                 "F" => ["C"]
               },
               workers: [%{doing: "C", wait: 2}, %{doing: nil, wait: 0}],
               time: 2,
               done: [],
               delay: 0
             }
    end

    test "it performs the third tick with sample input" do
      result =
        Day07.tick(%{
          todo: %{
            "A" => ["C"],
            "B" => ["A"],
            "D" => ["A"],
            "E" => ["F", "D", "B"],
            "F" => ["C"]
          },
          workers: [%{doing: "C", wait: 2}, %{doing: nil, wait: 0}],
          time: 2,
          done: [],
          delay: 0
        })

      assert result == %{
               todo: %{
                 "A" => ["C"],
                 "B" => ["A"],
                 "D" => ["A"],
                 "E" => ["F", "D", "B"],
                 "F" => ["C"]
               },
               workers: [%{doing: "C", wait: 1}, %{doing: nil, wait: 0}],
               time: 3,
               done: [],
               delay: 0
             }
    end

    test "it performs the fourth tick with sample input" do
      result =
        Day07.tick(%{
          todo: %{
            "A" => ["C"],
            "B" => ["A"],
            "D" => ["A"],
            "E" => ["F", "D", "B"],
            "F" => ["C"]
          },
          workers: [%{doing: "C", wait: 1}, %{doing: nil, wait: 0}],
          time: 3,
          done: [],
          delay: 0
        })

      assert result == %{
               todo: %{
                 "B" => ["A"],
                 "D" => ["A"],
                 "E" => ["F", "D", "B"]
               },
               workers: [%{doing: "A", wait: 1}, %{doing: "F", wait: 6}],
               time: 4,
               done: ["C"],
               delay: 0
             }
    end

    test "it performs the fifth tick with sample input" do
      result =
        Day07.tick(%{
          todo: %{
            "B" => [],
            "D" => [],
            "E" => ["F", "D", "B"],
            "F" => []
          },
          workers: [%{doing: "A", wait: 1}, %{doing: "F", wait: 6}],
          time: 4,
          done: ["C"],
          delay: 0
        })

      assert result == %{
               todo: %{
                 "D" => [],
                 "E" => ["F", "D", "B"],
                 "F" => []
               },
               workers: [%{doing: "B", wait: 2}, %{doing: "F", wait: 5}],
               time: 5,
               done: ["A", "C"],
               delay: 0
             }
    end
  end
end
