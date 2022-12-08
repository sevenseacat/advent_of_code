defmodule Y<%= @year %>.Day<%= @day %> do
  use Advent.Day, no: <%= @day %>

  @doc """
  iex> Day<%= @day %>.part1("update or delete me")
  "update or delete me"
  """
  def part1(input) do
    input
  end

  # @doc """
  # iex> Day<%= @day %>.part2("update or delete me")
  # "update or delete me"
  # """
  # def part2(input) do
  #   input
  # end

  @doc """
  iex> Day<%= @day %>.parse_input("update or delete me")
  "update or delete me"
  """
  def parse_input(input) do
    input
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  #def part2_verify, do: input() |> parse_input() |> part2()
end
