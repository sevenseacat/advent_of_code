defmodule Y2019.Day21 do
  use Advent.Day, no: 21
  alias Y2019.Intcode

  def part1(%Intcode{} = program) do
    program
    |> Intcode.add_inputs(~c"#{find_part_1_formula([:a, :b, :c, :d])}\nWALK\n")
    |> Intcode.run()
    |> Intcode.outputs()
    |> List.last()
  end

  # This doesn't actually ever finish
  # def part2(program) do
  #   result =
  #     program
  #     |> Intcode.add_inputs(
  #       ~c"#{find_part_2_formula([:a, :b, :c, :d, :e, :f, :g, :h, :i])}\nRUN\n"
  #     )
  #     |> Intcode.run()
  #     |> Intcode.outputs()

  #   IO.puts(result)

  #   List.last(result)
  # end

  def find_part_1_formula(vars) do
    [
      {[],
       [
         # If we're in front of a gap we have to jump
         {".###", true},
         {"..##", true},
         {".#.#", true},
         {"...#", true},

         # Never jump when the fourth square is a hole because you'll fall in it
         {"###.", false},
         {"#...", false},
         {"##..", false},
         {"#.#.", false},

         # Nothing to worry about, keep walking forward
         {"####", false},

         # Jump just in case you can't after the gap
         {"#..#", true},
         {"##.#", true}

         # These ones I don't know about yet because either move could work
         # [true, false, true, 1] => ?,
       ]
       |> expand_combinations(vars)}
    ]
    |> jump(possible_var_combinations(vars))
  end

  # def find_part_2_formula(vars) do
  #   [
  #     {
  #       [],
  #       [
  #         {".########", true},
  #         {"..#######", true},
  #         {"...######", true},
  #         {"#########", false},
  #         {"##.######", true},
  #         {"##...####", false},
  #         {".#.##.#.#", true},
  #         {"#.#.#####", false},
  #         {"#.#.##.#.", false},
  #         {"##.#.##.#", false},
  #         {"#...#####", false},
  #         {"##...####", false}
  #       ]
  #       |> expand_combinations(vars)
  #     }
  #   ]
  #   |> jump(possible_var_combinations(vars))
  # end

  defp expand_combinations(list, vars) do
    Enum.map(list, fn {road, result} ->
      bools =
        road
        |> String.graphemes()
        |> Enum.map(&(&1 == "#"))

      {Enum.zip(vars, bools) |> Map.new() |> Map.merge(%{t: false, j: false}), result}
    end)
  end

  def jump(possible_paths, var_combinations) do
    results =
      for [one, two] <- var_combinations,
          {name, op} <- possible_operations(),
          {path, list} <- possible_paths do
        {
          ["#{name} #{one} #{two}" | path],
          Enum.map(list, fn {registers, result} ->
            {Map.put(
               registers,
               two,
               op.([Map.fetch!(registers, one), Map.fetch!(registers, two)])
             ), result}
          end)
        }
      end
      # If we're back where we started from, ditch this option
      |> Enum.reject(fn {_path, results} ->
        Enum.all?(results, fn {registers, _} -> registers.j == false && registers.t == false end)
      end)

    match =
      Enum.find(results, fn {_path, list} ->
        Enum.all?(list, fn {registers, result} -> registers.j == result end)
      end)

    if match do
      {path, _} = match

      path
      |> Enum.reverse()
      |> Enum.map(&String.upcase/1)
      |> Enum.join("\n")
      |> String.to_charlist()
    else
      jump(results, var_combinations)
    end
  end

  def possible_operations do
    [
      {"not", fn [a, _] -> !a end},
      {"or", fn [a, b] -> a || b end},
      {"and", fn [a, b] -> a && b end}
    ]
  end

  def possible_var_combinations(range) do
    [[:t, :j] | Enum.flat_map(range, fn from -> [[from, :t], [from, :j]] end)]
  end

  def parse_input(input) do
    input
    |> Intcode.from_string()
    |> Intcode.new()
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  # def part2_verify, do: input() |> parse_input() |> part2()
end
