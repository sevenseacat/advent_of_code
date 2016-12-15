defmodule Y2016.Day12 do
  use Advent.Day, no: 12

  @doc """
  iex> Day12.run_assembunny_code(["cpy 41 a", "inc a", "inc a", "dec a", "jnz a 2", "dec a"]) |> elem(0)
  42
  """
  def run_assembunny_code(input) do
    execute_instructions(input, input, {0, 0, 0, 0}, 0)
  end

  def run_new_assembunny_code(input) do
    execute_instructions(input, input, {0, 0, 1, 0}, 0)
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

  def execute_instructions([], _input, state, _index), do: state

  def execute_instructions([line | _lines], input, state, index) do
    {state, index} =
      line
      |> String.split(" ")
      |> execute_instruction(state, index)

    {_run, lines} = Enum.split(input, index)
    execute_instructions(lines, input, state, index)
  end

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

  defp parse_input(input), do: String.split(input, "\n", trim: true)

  def register_val(state, letter) when letter in ["a", "b", "c", "d"],
    do: elem(state, register(letter))

  def register_val(_, letter), do: String.to_integer(letter)

  def part1_verify, do: input() |> parse_input() |> run_assembunny_code() |> elem(0)
  def part2_verify, do: input() |> parse_input() |> run_new_assembunny_code() |> elem(0)
end
