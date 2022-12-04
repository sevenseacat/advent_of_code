defmodule Y2016.Day25 do
  use Advent.Day, no: 25
  alias Y2016.Day12

  def part1(input) do
    expected = Stream.cycle([0, 1]) |> Enum.take(10)
    run_assembunny_code(input, expected, 0)
  end

  defp run_assembunny_code(input, expected, register_a) do
    result = execute_instructions(input, {register_a, 0, 0, 0}, 0, [])

    if result == expected do
      register_a
    else
      run_assembunny_code(input, expected, register_a + 1)
    end
  end

  defp execute_instructions(_, _, _, cache) when length(cache) == 10 do
    Enum.reverse(cache)
  end

  # This is a slight modification from the `run_assembunny_code/2` function from day 12
  # to capture output from output commands
  defp execute_instructions(input, state, index, cache) do
    case Day12.execute_instruction(Map.get(input, index), state, index, input) do
      {state, index, input} -> execute_instructions(input, state, index, cache)
      [{state, index, input}, val] -> execute_instructions(input, state, index, [val | cache])
    end
  end

  def part1_verify, do: input() |> Day12.parse_input() |> part1()
end
