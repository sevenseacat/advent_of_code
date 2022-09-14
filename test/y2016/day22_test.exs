defmodule Y2016.Day22Test do
  use ExUnit.Case, async: true
  alias Y2016.Day22
  doctest Day22

  test "verification, part 1", do: assert(Day22.part1_verify() == 987)

  describe "parse_input/1" do
    test "sample input" do
      input = """
      root@ebhq-gridcenter# df -h
      Filesystem              Size  Used  Avail  Use%
      /dev/grid/node-x0-y0     89T   65T    24T   73%
      /dev/grid/node-x0-y1    212T  101T   111T   70%
      """

      assert Day22.parse_input(input) == [
               %{x: 0, y: 0, size: 89, used: 65, available: 24, use: 73},
               %{x: 0, y: 1, size: 212, used: 101, available: 111, use: 70}
             ]
    end
  end
end
