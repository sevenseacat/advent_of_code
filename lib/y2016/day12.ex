defmodule Y2016.Day12 do
  use Advent.Day, no: 12

  @doc """
  iex> Day12.run_assembunny_code(%{0 => ["cpy", "41", "a"], 1 => ["inc", "a"], 2 => ["inc", "a"],
  ...>  3 => ["dec", "a"], 4 => ["jnz", "a", "2"], 5 => ["dec", "a"]}) |> elem(0)
  42

  iex> Day12.run_assembunny_code(%{0 => ["cpy", "2", "a"], 1 => ["tgl", "a"], 2 => ["tgl", "a"],
  ...>  3 => ["tgl", "a"], 4 => ["cpy", "1", "a"], 5 => ["dec", "a"], 6 => ["dec", "a"]}) |> elem(0)
  3
  """
  def run_assembunny_code(input, registers \\ {0, 0, 0, 0}) do
    execute_instructions(input, registers, 0)
  end

  defp execute_instructions(input, state, index) do
    if command = Map.get(input, index) do
      {state, index, input} = execute_instruction(command, state, index, input)
      execute_instructions(input, state, index)
    else
      state
    end
  end

  @doc """
  iex> Day12.execute_instruction(["inc", "b"], {2, 3, 4, 5}, 1, nil)
  {{2, 4, 4, 5}, 2, nil}

  iex> Day12.execute_instruction(["dec", "c"], {2, 3, 4, 5}, 4, nil)
  {{2, 3, 3, 5}, 5, nil}

  iex> Day12.execute_instruction(["cpy", "47", "a"], {2, 3, 4, 5}, 7, nil)
  {{47, 3, 4, 5}, 8, nil}

  iex> Day12.execute_instruction(["jnz", "a", "2"], {2, 3, 4, 5}, 2, nil)
  {{2, 3, 4, 5}, 4, nil}

  iex> Day12.execute_instruction(["jnz", "a", "-1"], {0, 3, 4, 5}, 2, nil)
  {{0, 3, 4, 5}, 3, nil}

  iex> Day12.execute_instruction(["jnz", "1", "2"], {2, 3, 4, 5}, 2, nil)
  {{2, 3, 4, 5}, 4, nil}

  iex> Day12.execute_instruction(["jnz", "0", "-1"], {2, 3, 4, 5}, 2, nil)
  {{2, 3, 4, 5}, 3, nil}

  iex> Day12.execute_instruction(["tgl", "a"], {0, 3, 4, 5}, 2, %{0 => ["inc", "b"], 1 => ["tgl", "a"]})
  {{0, 3, 4, 5}, 3, %{0 => ["inc", "b"], 1 => ["tgl", "a"]}}

  iex> Day12.execute_instruction(["tgl", "a"], {0, 3, 4, 5}, 1, %{0 => ["inc", "b"], 1 => ["tgl", "a"]})
  {{0, 3, 4, 5}, 2, %{0 => ["inc", "b"], 1 => ["inc", "a"]}}
  """
  def execute_instruction(["inc", letter], state, index, input) do
    new_state = put_elem(state, register(letter), elem(state, register(letter)) + 1)
    {new_state, index + 1, input}
  end

  def execute_instruction(["dec", letter], state, index, input) do
    new_state = put_elem(state, register(letter), elem(state, register(letter)) - 1)
    {new_state, index + 1, input}
  end

  def execute_instruction(["cpy", value, letter], state, index, input) do
    new_state = put_elem(state, register(letter), register_val(state, value))
    {new_state, index + 1, input}
  end

  def execute_instruction(["jnz", letter, move], state, index, input) do
    # move has to be a number!
    case register_val(state, letter) do
      0 -> {state, index + 1, input}
      _ -> {state, index + register_val(state, move), input}
    end
  end

  def execute_instruction(["tgl", letter], state, index, input) do
    target_index = register_val(state, letter)

    case Map.get(input, target_index + index) |> invert_instruction() do
      nil ->
        {state, index + 1, input}

      cmd ->
        {state, index + 1, Map.put(input, target_index + index, cmd)}
    end
  end

  defp invert_instruction(nil), do: nil
  defp invert_instruction(["inc", val]), do: ["dec", val]
  defp invert_instruction([_, val]), do: ["inc", val]
  defp invert_instruction(["jnz", one, two]), do: ["cpy", one, two]
  defp invert_instruction([_, one, two]), do: ["jnz", one, two]

  def register(key) do
    %{"a" => 0, "b" => 1, "c" => 2, "d" => 3}[key]
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, " "))
    |> Enum.with_index()
    |> Map.new(fn {cmd, index} -> {index, cmd} end)
  end

  def register_val(state, letter) when letter in ["a", "b", "c", "d"],
    do: elem(state, register(letter))

  def register_val(_, letter), do: String.to_integer(letter)

  def part1_verify, do: input() |> parse_input() |> run_assembunny_code({0, 0, 0, 0}) |> elem(0)
  def part2_verify, do: input() |> parse_input() |> run_assembunny_code({0, 0, 1, 0}) |> elem(0)
end
