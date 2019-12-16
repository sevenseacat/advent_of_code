defmodule Y2019.Intcode do
  defstruct program: :array.new(),
            inputs: [],
            pointer: 0,
            outputs: [],
            base: 0,
            status: :not_started,
            debug: false

  alias __MODULE__

  def new(program, inputs \\ []) do
    %Intcode{program: program, inputs: inputs}
  end

  def run(%Intcode{} = intcode) do
    intcode = set_status(intcode, :running)

    {modes, opcode} = parse_opcode(intcode)

    case opcode do
      1 ->
        intcode
        |> cmd_calc(modes, &Kernel.+/2)
        |> run

      2 ->
        intcode
        |> cmd_calc(modes, &Kernel.*/2)
        |> run

      3 ->
        case Map.get(intcode, :inputs) do
          [first | rest] ->
            intcode
            |> cmd_assign(modes, first)
            |> set_inputs(rest)
            |> run

          [] ->
            set_status(intcode, :paused)
        end

      4 ->
        intcode
        |> cmd_output(modes)
        |> run

      5 ->
        intcode
        |> cmd_jump_if(modes, &Kernel.!=/2)
        |> run

      6 ->
        intcode
        |> cmd_jump_if(modes, &Kernel.==/2)
        |> run

      7 ->
        intcode
        |> cmd_comparison(modes, &Kernel.</2)
        |> run

      8 ->
        intcode
        |> cmd_comparison(modes, &Kernel.==/2)
        |> run

      9 ->
        intcode
        |> update_base(modes)
        |> run

      99 ->
        set_status(intcode, :halted)

      val ->
        {:error,
         "'#{val}' at position #{Map.get(intcode, :pointer)} does not match a valid opcode"}
    end
  end

  def cmd_assign(intcode, modes, val) do
    intcode
    |> update_program(write_pointer(intcode, modes, 1), val)
    |> increment_pointer(2)
  end

  defp cmd_calc(intcode, modes, func) do
    arg1 = value(intcode, modes, 1)
    arg2 = value(intcode, modes, 2)

    intcode
    |> update_program(write_pointer(intcode, modes, 3), func.(arg1, arg2))
    |> increment_pointer(4)
  end

  def cmd_comparison(intcode, modes, func) do
    arg1 = value(intcode, modes, 1)
    arg2 = value(intcode, modes, 2)

    new_val = if func.(arg1, arg2), do: 1, else: 0

    intcode
    |> update_program(write_pointer(intcode, modes, 3), new_val)
    |> increment_pointer(4)
  end

  def cmd_jump_if(intcode, modes, func) do
    if func.(value(intcode, modes, 1), 0) do
      set_pointer(intcode, value(intcode, modes, 2))
    else
      increment_pointer(intcode, 3)
    end
  end

  # array, pos, modes, outputs, base) do
  defp cmd_output(intcode, modes) do
    intcode
    |> add_output(value(intcode, modes, 1))
    |> increment_pointer(2)
  end

  defp value(%Intcode{program: program, pointer: pointer, base: base}, modes, offset) do
    case String.at(modes, offset - 1) do
      "1" ->
        :array.get(pointer + offset, program)

      "2" ->
        :array.get(:array.get(pointer + offset, program) + base, program)

      # Might be 0 or a trailing nil
      _ ->
        :array.get(:array.get(pointer + offset, program), program)
    end
  end

  def write_pointer(%Intcode{program: program, pointer: pointer, base: base}, modes, offset) do
    case String.at(modes, offset - 1) do
      "2" ->
        :array.get(pointer + offset, program) + base

      _ ->
        :array.get(pointer + offset, program)
    end
  end

  defp parse_opcode(%Intcode{program: program, pointer: pointer}) do
    raw_opcode = :array.get(pointer, program)

    modes = div(raw_opcode, 100) |> Integer.to_string() |> String.reverse()
    opcode = rem(raw_opcode, 100)

    {modes, opcode}
  end

  # The only functions that should update the Intcode program struct.
  def debug!(intcode) do
    Map.put(intcode, :debug, true)
  end

  def add_input(intcode, input) do
    Map.update!(intcode, :inputs, fn i -> i ++ [input] end)
  end

  defp add_output(intcode, output) do
    Map.update!(intcode, :outputs, fn o -> [output | o] end)
  end

  defp set_pointer(intcode, val) do
    Map.put(intcode, :pointer, val)
  end

  defp increment_pointer(intcode, val) do
    Map.update!(intcode, :pointer, fn p -> p + val end)
  end

  defp update_base(intcode, modes) do
    intcode
    |> Map.update!(:base, fn b -> b + value(intcode, modes, 1) end)
    |> increment_pointer(2)
  end

  defp update_program(intcode, position, value) do
    Map.update!(intcode, :program, fn p -> :array.set(position, value, p) end)
  end

  defp set_inputs(intcode, inputs) do
    Map.put(intcode, :inputs, inputs)
  end

  defp set_status(intcode, status) do
    Map.put(intcode, :status, status)
  end

  # Return and clear outputs in one fell swoop.
  def pop_outputs(intcode) do
    {outputs(intcode), Map.put(intcode, :outputs, [])}
  end

  # Accessors
  def outputs(%Intcode{outputs: outputs}), do: Enum.reverse(outputs)
  def status(%Intcode{status: status}), do: status

  def from_string(string) do
    string
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> :array.from_list(0)
  end
end
