defmodule Y2022.Day23 do
  use Advent.Day, no: 23
  alias Advent.Grid

  def part1(input, rounds \\ 10) do
    input
    |> do_rounds(1, rounds + 1, 0)
    |> empty_square_count()
  end

  def part2(input, rounds \\ 10000) do
    input
    |> do_rounds(1, rounds + 1, 0)
  end

  defp do_rounds(set, round, round, _offset), do: set

  defp do_rounds(set, round, max_round, offset) do
    proposed_moves =
      Enum.reduce(set, [], fn coord, moves ->
        [{coord, next_position(coord, set, offset)} | moves]
      end)
      |> Enum.reject(fn {from, to} -> from == to end)

    grouped_moves = Enum.group_by(proposed_moves, fn {_, to} -> to end)

    actual_moves =
      Enum.filter(proposed_moves, fn {_coord, to} ->
        length(Map.fetch!(grouped_moves, to)) == 1
      end)

    if Enum.empty?(actual_moves) do
      round
    else
      actual_moves
      |> Enum.reduce(set, fn {from, to}, set ->
        set
        |> MapSet.delete(from)
        |> MapSet.put(to)
      end)
      |> do_rounds(round + 1, max_round, rem(offset + 1, 4))
    end
  end

  defp next_position({row, col}, set, offset) do
    # 012
    # 3x4
    # 567
    all_surrounds = [
      {row - 1, col - 1},
      {row - 1, col},
      {row - 1, col + 1},
      {row, col - 1},
      {row, col + 1},
      {row + 1, col - 1},
      {row + 1, col},
      {row + 1, col + 1}
    ]

    moves = [
      {1, [0, 1, 2]},
      {6, [5, 6, 7]},
      {3, [0, 3, 5]},
      {4, [2, 4, 7]}
    ]

    if Enum.all?(all_surrounds, fn coord -> !MapSet.member?(set, coord) end) do
      # All surrounds empty, don't move
      {row, col}
    else
      # Maybe move in a direction?
      moves = Enum.drop(moves, offset) ++ Enum.take(moves, offset)

      if move =
           Enum.find(moves, fn {_maybe, conds} ->
             Enum.all?(conds, &(!MapSet.member?(set, Enum.at(all_surrounds, &1))))
           end) do
        Enum.at(all_surrounds, elem(move, 0))
      else
        # No valid moves, don't move
        {row, col}
      end
    end
  end

  defp empty_square_count(set) do
    {{min_row, _}, {max_row, _}} = Enum.min_max_by(set, fn {row, _col} -> row end)
    {{_, min_col}, {_, max_col}} = Enum.min_max_by(set, fn {_row, col} -> col end)

    for(row <- min_row..max_row, col <- min_col..max_col, do: {row, col})
    |> Enum.filter(fn coord -> !MapSet.member?(set, coord) end)
    |> Enum.count()
  end

  def parse_input(input) do
    input
    |> Grid.new()
    |> Enum.filter(fn {_coord, val} -> val == "#" end)
    |> Enum.map(&elem(&1, 0))
    |> MapSet.new()
  end

  def display(set, round_no) do
    {{min_row, _}, {max_row, _}} = Enum.min_max_by(set, fn {row, _col} -> row end)
    {{_, min_col}, {_, max_col}} = Enum.min_max_by(set, fn {_row, col} -> col end)

    IO.inspect(round_no, label: "Round")
    IO.inspect({min_row, max_row}, label: "Rows")
    IO.inspect({min_col, max_col}, label: "Col")

    for(row <- min_row..max_row, col <- min_col..max_col, do: {row, col})
    |> Enum.map(fn coord -> if MapSet.member?(set, coord), do: "#", else: "." end)
    |> Enum.chunk_every(max_col - min_col + 1)
    |> Enum.map(&List.to_string/1)
    |> Enum.map(&IO.puts/1)

    set
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  def part2_verify, do: input() |> parse_input() |> part2()
end
