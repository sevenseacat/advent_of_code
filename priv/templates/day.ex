defmodule Y<%= @year %>.Day<%= @day %> do
  use Advent.Day, no: <%= @day %>

  @doc """
  iex> Day<%= @day %>.part1(:parsed_input)
  :ok
  """
  def part1(_input) do
    :ok
  end

  @doc """
  iex> Day<%= @day %>.parse_input("YOURSAMPLEINPUTHERE")
  []
  """
  def parse_input(_input) do
    []
  end

  def part1_verify, do: part1(:ok)
end
