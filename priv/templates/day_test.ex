defmodule Y<%= @year %>.Day<%= @day %>Test do
  use ExUnit.Case, async: true
  alias Y<%= @year %>.Day<%= @day %>
  doctest Day<%= @day %>

  test "verification, part 1", do: assert(Day<%= @day %>.part1_verify() == "update or delete me")
  # test "verification, part 2", do: assert(Day<%= @day %>.part2_verify() == "update or delete me")
end
