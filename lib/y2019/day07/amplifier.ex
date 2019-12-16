defmodule Y2019.Day07.Amplifier do
  alias __MODULE__
  alias Y2019.Intcode

  use GenServer

  def start_link(id, target, setting, program) do
    GenServer.start_link(
      __MODULE__,
      %{id: id, target: target, intcode: Intcode.new(program, [setting])},
      name: {:global, id}
    )
  end

  def check_for_result(amp) do
    GenServer.call({:global, amp}, :check_for_result)
  end

  def send_input(amp, input) do
    GenServer.cast({:global, amp}, {:input, input})
  end

  def stop(amp) do
    GenServer.stop({:global, amp})
  end

  def init(state), do: {:ok, state}

  def handle_call(:check_for_result, _, {:halted, val} = state) when val != nil do
    {:reply, val, state}
  end

  def handle_call(:check_for_result, _, state), do: {:reply, nil, state}

  def handle_cast({:input, input}, {:halted, nil}) do
    # This is what should go to the thruster!
    {:noreply, {:halted, input}}
  end

  def handle_cast({:input, input}, %{id: id, target: target, intcode: intcode}) do
    intcode =
      intcode
      |> Intcode.add_input(input)
      |> Intcode.run()

    case Intcode.status(intcode) do
      :halted ->
        Enum.each(Intcode.outputs(intcode), fn o -> Amplifier.send_input(target, o) end)
        {:noreply, {:halted, nil}}

      :paused ->
        {outputs, intcode} = Intcode.pop_outputs(intcode)

        Enum.each(outputs, fn o -> Amplifier.send_input(target, o) end)
        {:noreply, %{id: id, target: target, intcode: intcode}}
    end
  end
end
