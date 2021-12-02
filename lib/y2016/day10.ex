defmodule Y2016.Day10 do
  use Advent.Day, no: 10

  alias Y2016.Day10.{Bot, Output}

  @doc """
  iex> Day10.process_input(["value 5 goes to bot 2",
  ...>  "bot 2 gives low to bot 1 and high to bot 0",
  ...>  "value 3 goes to bot 1",
  ...>  "bot 1 gives low to output 1 and high to bot 0",
  ...>  "bot 0 gives low to output 2 and high to output 0",
  ...>  "value 2 goes to bot 2"])
  %{
    {:bot, 0} => %Bot{holding: [], low_to: {:output, 2}, high_to: {:output, 0}, status: :pending, comparisons: MapSet.new()},
    {:bot, 1} => %Bot{holding: [3], low_to: {:output, 1}, high_to: {:bot, 0}, status: :pending, comparisons: MapSet.new()},
    {:bot, 2} => %Bot{holding: [2, 5], low_to: {:bot, 1}, high_to: {:bot, 0}, status: :pending, comparisons: MapSet.new()},
    {:output, 0} => %Output{holding: nil},
    {:output, 1} => %Output{holding: nil},
    {:output, 2} => %Output{holding: nil}
  }
  """
  def process_input(list, state \\ %{})
  def process_input([], state), do: state

  def process_input([line | lines], state) do
    state = line |> String.split() |> process_command(state)
    process_input(lines, state)
  end

  def process_command(["value", value, "goes", "to", "bot", bot_no], state) do
    bot_key = key("bot", bot_no)
    bot = Map.get(state, bot_key, Bot.new())
    Map.put(state, bot_key, Bot.hold(bot, value))
  end

  def process_command(
        [
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
        ],
        state
      ) do
    bot_key = key("bot", bot_no)
    low_key = key(low_type, low_id)
    high_key = key(high_type, high_id)

    bot =
      Map.get(state, bot_key, Bot.new())
      |> Bot.set_rule(low_key, high_key)

    state
    |> Map.put_new(low_key, new(low_type))
    |> Map.put_new(high_key, new(high_type))
    |> Map.put(bot_key, bot)
  end

  @doc """
  iex> Day10.process_input(["value 5 goes to bot 2",
  ...>  "bot 2 gives low to bot 1 and high to bot 0",
  ...>  "value 3 goes to bot 1",
  ...>  "bot 1 gives low to output 1 and high to bot 0",
  ...>  "bot 0 gives low to output 2 and high to output 0",
  ...>  "value 2 goes to bot 2"]) |>
  ...>  Day10.process_rules() |> Day10.find_comparison({2, 5})
  {:bot, 2}
  """
  def run_scenario do
    parse_input() |> process_input() |> process_rules() |> find_comparison({17, 61})
  end

  def process_rules(state) do
    state = Enum.reduce(state, state, &take_action/2)

    case Enum.all?(state, fn {_key, object} -> object.status == :done end) do
      true -> state
      false -> process_rules(state)
    end
  end

  defp take_action({_, %Output{}}, state), do: state

  defp take_action({_, %Bot{holding: holding}}, state) when length(holding) < 2, do: state

  defp take_action({bot_key, %Bot{} = bot}, state) do
    {low, high} = Enum.min_max(bot.holding)

    state
    |> Map.put(bot_key, Bot.drop_pieces(bot, {low, high}))
    |> Map.update!(bot.low_to, &hold(&1, low))
    |> Map.update!(bot.high_to, &hold(&1, high))
  end

  def find_comparison(state, comp) do
    state
    |> Enum.find(fn {_key, bot} -> Bot.made_comparison?(bot, comp) end)
    |> elem(0)
  end

  def find_outputs(state, ids) do
    state
    |> Enum.filter(fn {{type, id}, _bot} -> type == :output && Enum.member?(ids, id) end)
    |> Enum.map(fn {_key, bot} -> bot end)
  end

  def parse_input do
    input() |> String.split("\n")
  end

  defp key(label, number), do: {String.to_atom(label), String.to_integer(number)}
  defp new("output"), do: Output.new()
  defp new("bot"), do: Bot.new()

  defp hold(%Output{} = output, value), do: Output.hold(output, value)
  defp hold(%Bot{} = output, value), do: Bot.hold(output, value)

  def part1_verify, do: run_scenario() |> elem(1)

  def part2_verify do
    parse_input()
    |> process_input()
    |> process_rules()
    |> find_outputs([0, 1, 2])
    |> Enum.map(& &1.holding)
    |> Enum.reduce(&*/2)
  end
end
