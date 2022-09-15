defmodule Y2016.Day22Test do
  use ExUnit.Case, async: true
  alias Y2016.Day22
  doctest Day22

  test "verification, part 1", do: assert(Day22.part1_verify() == 987)

  @tag timeout: :infinity
  test "verification, part 2", do: assert(Day22.part2_verify() == 220)

  describe "part2/1" do
    test "sample input" do
      input = test_data("part2_sample") |> Day22.parse_input()
      assert 7 == Day22.part2(input)
    end
  end

  describe "parse_input/1" do
    test "sample input" do
      input = """
      root@ebhq-gridcenter# df -h
      Filesystem              Size  Used  Avail  Use%
      /dev/grid/node-x0-y0     89T   65T    24T   73%
      /dev/grid/node-x0-y1    212T  101T   111T   70%
      """

      assert Day22.parse_input(input) == %{
               {0, 0} => %{x: 0, y: 0, size: 89, used: 65, available: 24},
               {0, 1} => %{x: 0, y: 1, size: 212, used: 101, available: 111}
             }
    end
  end

  def test_data(name), do: File.read!("test/y2016/input/day22/#{name}.txt")
end
