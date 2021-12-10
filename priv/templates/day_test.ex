defmodule Y<%= @year %>.Day<%= @day %>Test do
  use ExUnit.Case, async: true
  alias Y<%= @year %>.Day<%= @day %>
  doctest Day<%= @day %>

  test "verification, part 1", do: assert(Day<%= @day %>.part1_verify() == :ok)
end
