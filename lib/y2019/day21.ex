defmodule Y2019.Day21 do
  use Advent.Day, no: 21
  alias Y2019.Intcode

  def part1(%Intcode{} = program) do
    program
    |> Intcode.add_inputs(~c"#{find_formula()}\nWALK\n")
    |> Intcode.run()
    |> Intcode.outputs()
    |> List.last()
  end

  # @doc """
  # iex> Day21.part2("update or delete me")
  # "update or delete me"
  # """
  # def part2(input) do
  #   input
  # end

  def find_formula do
    [
      {[],
       [
         # If we're in front of a gap we have to jump
         {%{a: false, b: false, c: false, d: true, t: false, j: false}, true},
         {%{a: false, b: false, c: true, d: true, t: false, j: false}, true},
         {%{a: false, b: true, c: false, d: true, t: false, j: false}, true},
         {%{a: false, b: true, c: true, d: true, t: false, j: false}, true},

         # Never jump when the fourth square is a hole because you'll fall in it
         {%{a: true, b: true, c: true, d: false, t: false, j: false}, false},
         {%{a: true, b: false, c: false, d: false, t: false, j: false}, false},
         {%{a: true, b: true, c: false, d: false, t: false, j: false}, false},
         {%{a: true, b: false, c: true, d: false, t: false, j: false}, false},

         # Nothing to worry about, keep walking forward
         {%{a: true, b: true, c: true, d: true, t: false, j: false}, false},

         # Jump just in case you can't after the gap
         {%{a: true, b: false, c: false, d: true, t: false, j: false}, true},
         {%{a: true, b: true, c: false, d: true, t: false, j: false}, true}

         # These ones I don't know about yet because either move could work
         # [true, false, true, 1] => ?,
       ]}
    ]
    |> jump()
  end

  def jump(stuff) do
    results =
      for [one, two] <- possible_var_combinations(),
          {name, op} <- possible_operations(),
          {path, list} <- stuff do
        {
          ["#{name} #{one} #{two}" | path],
          Enum.map(list, fn {registers, result} ->
            {Map.put(
               registers,
               two,
               op.([Map.fetch!(registers, one), Map.fetch!(registers, two)])
             ), result}
          end)
          |> Enum.uniq_by(fn data -> data end)
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
      jump(results)
    end
  end

  def possible_operations do
    [
      {"not", fn [a, _] -> !a end},
      {"or", fn [a, b] -> a || b end},
      {"and", fn [a, b] -> a && b end}
    ]
  end

  def possible_var_combinations do
    [
      [:a, :t],
      [:b, :t],
      [:c, :t],
      [:d, :t],
      [:j, :t],
      [:a, :j],
      [:b, :j],
      [:c, :j],
      [:d, :j],
      [:t, :j]
    ]
  end

  def parse_input(input) do
    input
    |> Intcode.from_string()
    |> Intcode.new()
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  # def part2_verify, do: input() |> parse_input() |> part2()
end
