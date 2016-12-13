defmodule Y2016.Day10 do
  use Advent.Day, no: 10

  alias Y2016.Day10.Bot

  @doc """
  iex> Day10.process_input(["value 5 goes to bot 2",
  ...>  "bot 2 gives low to bot 1 and high to bot 0",
  ...>  "value 3 goes to bot 1",
  ...>  "bot 1 gives low to output 1 and high to bot 0",
  ...>  "bot 0 gives low to output 2 and high to output 0",
  ...>  "value 2 goes to bot 2"], MapSet.new)
  #MapSet<[0, 1, 2]>
  """
  def process_input([], bot_nos), do: bot_nos

  def process_input([line | lines], bot_nos) do
    bot_no = line |> String.split() |> process_command
    process_input(lines, MapSet.put(bot_nos, bot_no))
  end

  def process_command(["value", value, "goes", "to", "bot", bot_no]) do
    bot_no = String.to_integer(bot_no)
    Bot.take_piece(bot_no, String.to_integer(value))
    bot_no
  end

  def process_command([
        "bot",
        bot_no,
        "gives",
        "low",
        "to",
        low_type,
        low_id,
        "and",
        "high",
        "to",
        high_type,
        high_id
      ]) do
    bot_no = String.to_integer(bot_no)

    Bot.set_rule(
      bot_no,
      {String.to_atom(low_type), String.to_integer(low_id)},
      {String.to_atom(high_type), String.to_integer(high_id)}
    )

    bot_no
  end

  @doc """
  iex> Day10.process_input(["value 5 goes to bot 2",
  ...>  "bot 2 gives low to bot 1 and high to bot 0",
  ...>  "value 3 goes to bot 1",
  ...>  "bot 1 gives low to output 1 and high to bot 0",
  ...>  "bot 0 gives low to output 2 and high to output 0",
  ...>  "value 2 goes to bot 2"], MapSet.new) |>
  ...>  Day10.process_rules |> Day10.find_comparison({2, 5})
  2
  """
  def run_scenario do
    parse_input() |> process_input(MapSet.new()) |> process_rules |> find_comparison({17, 61})
  end

  def process_rules(bot_nos) do
    case Enum.all?(bot_nos, fn bot_no -> Bot.run(bot_no) == :pending end) do
      true -> :ok
      false -> process_rules(bot_nos)
    end

    bot_nos
  end

  def find_comparison(bot_nos, comp) do
    bot_nos
    |> Enum.find(fn bot_no -> Enum.member?(Bot.comparisons(bot_no), comp) end)
  end

  def parse_input do
    input() |> String.split("\n")
  end

  def part1_verify, do: run_scenario()
end
