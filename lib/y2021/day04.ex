defmodule Y2021.Day04 do
  use Advent.Day, no: 4

  @called_numbers "13,47,64,52,60,69,80,85,57,1,2,6,30,81,86,40,27,26,97,77,70,92,43,94,8,78,3,88,93,17,55,49,32,59,51,28,33,41,83,67,11,91,53,36,96,7,34,79,98,72,39,56,31,75,82,62,99,66,29,58,9,50,54,12,45,68,4,46,38,21,24,18,44,48,16,61,19,0,90,35,65,37,73,20,22,89,42,23,15,87,74,10,71,25,14,76,84,5,63,95"

  def part1(boards, called \\ @called_numbers) do
    called
    |> parse_called()
    |> play_bingo(boards)
    |> calculate_score()
  end

  def part2(boards, called \\ @called_numbers) do
    called
    |> parse_called()
    |> play_anti_bingo(boards)
    |> calculate_score()
  end

  defp play_bingo([], _boards), do: raise("No winners!")

  defp play_bingo([number | numbers], boards) do
    boards = Enum.map(boards, &mark_number_on_board(&1, number))

    case Enum.find(boards, &winning_board?/1) do
      nil -> play_bingo(numbers, boards)
      board -> {board, number}
    end
  end

  defp play_anti_bingo(_numbers, []), do: raise("Everyone wins! Oops")
  defp play_anti_bingo([], _boards), do: raise("No winners!")

  defp play_anti_bingo([number | numbers], boards) do
    non_winning_boards =
      boards
      |> Enum.map(&mark_number_on_board(&1, number))
      |> Enum.reject(&winning_board?/1)

    if length(non_winning_boards) == 0 && length(boards) == 1 do
      {hd(boards) |> mark_number_on_board(number), number}
    else
      play_anti_bingo(numbers, non_winning_boards)
    end
  end

  defp mark_number_on_board(board, number) do
    Enum.map(board, &mark_number_on_row(&1, number))
  end

  defp mark_number_on_row([], _to_mark), do: []

  defp mark_number_on_row([{to_mark, false} | rest], to_mark) do
    [{to_mark, true} | rest]
  end

  defp mark_number_on_row([square | rest], to_mark) do
    [square | mark_number_on_row(rest, to_mark)]
  end

  defp calculate_score({board, last_num}) do
    board
    |> List.flatten()
    |> Enum.filter(fn {_num, marked} -> !marked end)
    |> Enum.map(fn {num, _marked} -> num end)
    |> Enum.sum()
    |> then(fn num -> num * last_num end)
  end

  defp winning_board?(board) do
    winning_row?(board) || winning_column?(board)
  end

  defp winning_row?(board), do: Enum.any?(board, &all_marked?/1)

  defp winning_column?(board) do
    board
    |> Advent.transpose()
    |> winning_row?()
  end

  defp all_marked?(numbers), do: Enum.all?(numbers, fn {_num, marked} -> marked end)

  def parse_input(string) do
    string
    |> String.split("\n\n", trim: true)
    |> Enum.map(&parse_board/1)
  end

  defp parse_board(string) do
    string
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_row/1)
  end

  defp parse_row(string) do
    string
    |> String.trim()
    |> String.split(~r/\s+/)
    |> Enum.map(&parse_number/1)
  end

  # All squares are unmarked (false) by default.
  defp parse_number(string), do: {String.to_integer(string), false}

  defp parse_called(string) do
    string
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  def part2_verify, do: input() |> parse_input() |> part2()
end
