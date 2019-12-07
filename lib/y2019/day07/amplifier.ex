defmodule Y2019.Day07.Amplifier do
  alias __MODULE__
  use GenServer

  def start_link(id, target, setting, program) do
    GenServer.start_link(
      __MODULE__,
      %{id: id, position: 0, target: target, inputs: [setting], program: program},
      name: {:global, id}
    )
  end

  def send_input(amp, input) do
    GenServer.cast({:global, amp}, {:input, input})
  end

  def init(state), do: {:ok, state}

  def handle_cast({:input, input}, :halted) do
    # This is what should go to the thruster!
    IO.puts(input)
    {:noreply, nil}
  end

  def handle_cast({:input, input}, %{
        id: id,
        target: target,
        inputs: inputs,
        program: program,
        position: position
      }) do
    case Y2019.Day05.run_program(program, inputs ++ [input], position) do
      {:halt, {_program, outputs}} ->
        Enum.each(outputs, fn o -> Amplifier.send_input(target, o) end)
        {:noreply, :halted}

      {:pause, {program, outputs, position}} ->
        Enum.each(outputs, fn o -> Amplifier.send_input(target, o) end)
        {:noreply, %{id: id, inputs: [], program: program, target: target, position: position}}
    end
  end
end
