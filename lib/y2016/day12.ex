defmodule Y2016.Day12 do
  use Advent.Day, no: 12

  @doc """
  iex> Day12.run_assembunny_code(%{0 => ["cpy", "41", "a"], 1 => ["inc", "a"], 2 => ["inc", "a"],
  ...>  3 => ["dec", "a"], 4 => ["jnz", "a", "2"], 5 => ["dec", "a"]}) |> elem(0)
  42
  """
  def run_assembunny_code(input) do
    execute_instructions(input, {0, 0, 0, 0}, 0)
  end

  def run_new_assembunny_code(input) do
    execute_instructions(input, {0, 0, 1, 0}, 0)
  end

  defp execute_instructions(input, state, index) do
    if command = Map.get(input, index) do
      {state, index} = execute_instruction(command, state, index)
      execute_instructions(input, state, index)
    else
      state
    end
  end

  @doc """
  iex> Day12.execute_instruction(["inc", "b"], {2, 3, 4, 5}, 1)
  {{2, 4, 4, 5}, 2}

  iex> Day12.execute_instruction(["dec", "c"], {2, 3, 4, 5}, 4)
  {{2, 3, 3, 5}, 5}

  iex> Day12.execute_instruction(["cpy", "47", "a"], {2, 3, 4, 5}, 7)
  {{47, 3, 4, 5}, 8}

  iex> Day12.execute_instruction(["jnz", "a", "2"], {2, 3, 4, 5}, 2)
  {{2, 3, 4, 5}, 4}

  iex> Day12.execute_instruction(["jnz", "a", "-1"], {0, 3, 4, 5}, 2)
  {{0, 3, 4, 5}, 3}

  iex> Day12.execute_instruction(["jnz", "1", "2"], {2, 3, 4, 5}, 2)
  {{2, 3, 4, 5}, 4}

  iex> Day12.execute_instruction(["jnz", "0", "-1"], {2, 3, 4, 5}, 2)
  {{2, 3, 4, 5}, 3}
  """
  def execute_instruction(["inc", letter], state, index) do
    new_state = put_elem(state, register(letter), elem(state, register(letter)) + 1)
    {new_state, index + 1}
  end

  def execute_instruction(["dec", letter], state, index) do
    new_state = put_elem(state, register(letter), elem(state, register(letter)) - 1)
    {new_state, index + 1}
  end

  def execute_instruction(["cpy", value, letter], state, index) do
    new_state = put_elem(state, register(letter), register_val(state, value))
    {new_state, index + 1}
  end

  def execute_instruction(["jnz", letter, move], state, index) do
    case register_val(state, letter) do
      0 -> {state, index + 1}
      _ -> {state, index + String.to_integer(move)}
    end
  end

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

  def part1_verify, do: input() |> parse_input() |> run_assembunny_code() |> elem(0)
  def part2_verify, do: input() |> parse_input() |> run_new_assembunny_code() |> elem(0)
end
