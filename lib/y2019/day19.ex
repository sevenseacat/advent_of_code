defmodule Y2019.Day19 do
  use Advent.Day, no: 19
  alias Y2019.Intcode

  def part1(program) do
    program
    |> run_to_size(49)
    |> Enum.count(fn {_coord, val} -> val == 1 end)
  end

  def part2(program) do
    # The beam is actually made up of two lines and the area between them, so at
    # the core, this is a geometry problem.
    # What are the formulae for the two lines?
    # Through trial and error for one line:
    # verify_formula(program, 1)
    # The formula is now in row/1. It's good up until about col = 1_000_000 and
    # the answer will be found long before that.
    is_santa_hiding?(program, 0)
  end

  defp row(col), do: ceil(col * 1.671219)

  # defp verify_formula(program, col) do
  #   if run_program_for_inputs(program, [row(col), col]) == 1 &&
  #        run_program_for_inputs(program, [row(col), col + 1]) == 0 do
  #     if rem(y, 1000) == 0, do: IO.write(".")
  #     verify_formula(program, y + 1)
  #   else
  #     dbg(y)
  #   end
  # end

  defp is_santa_hiding?(program, col) do
    row = row(col)
    # {row, col} is the top right corner of the potential square
    # A 100x100 grid will only need 99 subtracted, eg. 1-100 covers 100 numbers
    square? =
      Enum.all?(
        [[row, col], [row + 99, col], [row + 99, col - 99], [row, col - 99]],
        fn inputs ->
          run_program_for_inputs(program, inputs) == 1
        end
      )

    if square? do
      # I have gotten severely confused between rows and columns and xs and ys while doing this puzzle.
      # If we find a square, the closest to the emitter (top left corner of square) is {row, col-99}.
      # The col *should* be x and the row *should* be y but after many trial and error guesses... it's not?
      # I also thought I would have an off-by-one error (due to one-indexing instead of zero-indexing)
      # but I didn't and this works to generate the answer.
      row * 10000 + col - 99
    else
      is_santa_hiding?(program, col + 1)
    end
  end

  defp run_to_size(program, size) do
    for(x <- 0..size, y <- 0..size, do: [x, y])
    |> Task.async_stream(fn [x, y] ->
      {{x, y}, run_program_for_inputs(program, [x, y])}
    end)
    |> Enum.map(fn {:ok, result} -> result end)
    |> Map.new()
  end

  defp run_program_for_inputs(program, inputs) do
    program
    |> Intcode.new(inputs)
    |> Intcode.run()
    |> Intcode.outputs()
    |> hd()
  end

  def parse_input(input) do
    Intcode.from_string(input)
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  def part2_verify, do: input() |> parse_input() |> part2()
end
