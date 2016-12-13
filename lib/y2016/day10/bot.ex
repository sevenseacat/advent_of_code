defmodule Y2016.Day10.Bot do
  use GenServer
  alias Y2016.Day10.{Bot, Output}

  # Public interface

  def new({:output, number}) do
    Output.new(number)
  end

  def new({:bot, number}), do: new(number)

  def new(number) do
    GenServer.start_link(__MODULE__, number, name: via_tuple(number))
  end

  def take_piece(bot_no, value) do
    ensure_started(bot_no)
    GenServer.call(via_tuple(bot_no), {:take_piece, value})
  end

  def set_rule(bot_no, low, high) do
    ensure_started(bot_no)
    GenServer.cast(via_tuple(bot_no), {:set_rule, low, high})
  end

  def run(bot_no) do
    ensure_started(bot_no)
    GenServer.call(via_tuple(bot_no), :run)
  end

  def comparisons(bot_no) do
    ensure_started(bot_no)
    GenServer.call(via_tuple(bot_no), :comparisons)
  end

  def terminate_all(bot_nos) do
    Enum.each(bot_nos, &GenServer.stop(via_tuple(&1)))
  end

  # Callbacks

  # We only store the bot number for debugging purposes. Pain to figure out what's going on, otherwise.
  def init(number), do: {:ok, {number, [], nil, MapSet.new()}}

  def handle_cast({:set_rule, low, high}, {number, pieces, _rule, comps}) do
    {:noreply, {number, pieces, {low, high}, comps}}
  end

  def handle_call({:take_piece, piece}, _from, {number, pieces, rule, comps}) do
    {:reply, :ok, {number, [piece | pieces], rule, comps}}
  end

  def handle_call(:run, _from, {_number, pieces, _rule, _comps} = state)
      when length(pieces) < 2 do
    {:reply, :pending, state}
  end

  def handle_call(:run, _from, {number, pieces, {low_dest, high_dest} = rule, comps}) do
    {low, high} = Enum.min_max(pieces)
    Bot.take_piece(low_dest, low)
    Bot.take_piece(high_dest, high)
    {:reply, :ok, {number, [], rule, MapSet.put(comps, {low, high})}}
  end

  def handle_call(:comparisons, _from, {_number, _pieces, _rule, comps} = state),
    do: {:reply, comps, state}

  # Private methods

  defp ensure_started(id) do
    {_, _, name} = via_tuple(id)

    case :gproc.where(name) do
      :undefined -> Bot.new(id)
      process -> process
    end
  end

  defp via_tuple(id), do: {:via, :gproc, gproc_key(id)}

  defp gproc_key(id) when is_tuple(id), do: {:n, :l, id}
  defp gproc_key(id), do: {:n, :l, {:bot, id}}
end
