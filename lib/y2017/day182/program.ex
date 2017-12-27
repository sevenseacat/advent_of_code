defmodule Y2017.Day182.Program do
  use GenServer

  alias __MODULE__

  ### Public interface
  def new(name, initial_value, commands) do
    GenServer.start_link(
      __MODULE__,
      %{
        name: name,
        commands: commands,
        status: :running,
        data: initial_value,
        index: 0,
        queue: [],
        waiting_for: nil,
        other: nil,
        send_count: 0
      },
      name: name
    )
  end

  def add_references(a, b) do
    GenServer.cast(:a, {:set_other, b})
    GenServer.cast(:b, {:set_other, a})
  end

  def next_command(pid), do: GenServer.call(pid, :next_command)

  def waiting?(pid), do: GenServer.call(pid, :status) == :waiting

  def add_to_queue(pid, value), do: GenServer.call(pid, {:add_to_queue, value})

  def send_count(pid), do: GenServer.call(pid, :send_count)

  ### Callbacks

  def init(state), do: {:ok, state}

  def handle_call(:send_count, _from, state), do: {:reply, state.send_count, state}
  def handle_call(:status, _from, state), do: {:reply, state.status, state}

  # If waiting to receive, we process no other stuff.
  def handle_call(:next_command, _from, %{status: :waiting} = state) do
    {:reply, :ok, state}
  end

  def handle_call(:next_command, _from, state) do
    new_state = state |> get_command |> perform_command(state)
    {:reply, :ok, new_state}
  end

  def handle_call(
        {:add_to_queue, value},
        _from,
        %{status: :waiting, waiting_for: waiting_for, data: data} = state
      ) do
    data = Map.put(data, waiting_for, value)
    {:reply, :ok, %{state | status: :running, waiting_for: nil, data: data}}
  end

  def handle_call({:add_to_queue, value}, _from, state) do
    {:reply, :ok, Map.update!(state, :queue, &(&1 ++ [value]))}
  end

  def handle_cast({:set_other, other}, state) do
    {:noreply, %{state | other: other}}
  end

  ### Other internal code

  defp get_command(state), do: Enum.at(state.commands, state.index)

  defp perform_command({:add, one, two}, %{data: data} = state) do
    data = Map.update(data, one, two, &(&1 + v(data, two)))
    %{state | index: state.index + 1, data: data}
  end

  defp perform_command({:assign, one, two}, %{data: data} = state) do
    data = Map.put(data, one, v(data, two))
    %{state | index: state.index + 1, data: data}
  end

  defp perform_command({:multiply, one, two}, %{data: data} = state) do
    data = Map.update(data, one, 0, &(&1 * v(data, two)))
    %{state | index: state.index + 1, data: data}
  end

  defp perform_command({:modulo, one, two}, %{data: data} = state) do
    two = v(data, two)
    data = Map.update(data, one, 0, &rem(&1, two))
    %{state | index: state.index + 1, data: data}
  end

  defp perform_command({:send, one}, state) do
    Program.add_to_queue(state.other, v(state.data, one))
    %{state | index: state.index + 1, send_count: state.send_count + 1}
  end

  defp perform_command({:receive, one}, %{queue: queue, data: data} = state) do
    if queue == [] do
      # ah nooooooo
      %{state | status: :waiting, waiting_for: one, index: state.index + 1}
    else
      data = Map.put(data, one, hd(queue))
      %{state | data: data, queue: tl(queue), index: state.index + 1}
    end
  end

  defp perform_command({:jump, one, two}, %{data: data, index: index} = state) do
    offset = if v(data, one) > 0, do: v(data, two), else: 1
    %{state | index: index + offset}
  end

  defp v(_, val) when is_integer(val), do: val
  defp v(data, val), do: Map.get(data, val, 0)
end
