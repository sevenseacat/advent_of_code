defmodule Y2016.Day21 do
  use Advent.Day, no: 21

  @string "abcdefgh"

  def part1(cmds, string \\ @string) do
    list = String.graphemes(string)

    cmds
    |> Enum.reduce(list, &run_command/2)
    |> Enum.join()
  end

  def run_command({:swap_position, from, to}, list) do
    list
    |> List.replace_at(from, Enum.at(list, to))
    |> List.replace_at(to, Enum.at(list, from))
  end

  def run_command({:rotate_left, count}, list) do
    count = rem(count, length(list))
    {head, tail} = Enum.split(list, count)
    tail ++ head
  end

  def run_command({:rotate_right, count}, list) do
    count = rem(count, length(list))
    {head, tail} = Enum.split(list, -count)
    tail ++ head
  end

  def run_command({:move_position, from, to}, list) do
    moved = Enum.at(list, from)

    list
    |> List.delete_at(from)
    |> List.insert_at(to, moved)
  end

  def run_command({:rotate_position, letter}, list) do
    index =
      case Enum.find_index(list, &(&1 == letter)) do
        index when index >= 4 -> index + 2
        index -> index + 1
      end

    run_command({:rotate_right, index}, list)
  end

  def run_command({:swap_letter, from, to}, list) do
    from_index = Enum.find_index(list, &(&1 == from))
    to_index = Enum.find_index(list, &(&1 == to))

    list
    |> List.replace_at(from_index, to)
    |> List.replace_at(to_index, from)
  end

  def run_command({:reverse, from, to}, list) do
    {start, rest} = Enum.split(list, from)
    {to_reverse, rest} = Enum.split(rest, to - from + 1)
    start ++ Enum.reverse(to_reverse) ++ rest
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn row ->
      case row do
        <<"swap position ", from::binary-1, " with position ", to::binary-1>> ->
          {:swap_position, i(from), i(to)}

        <<"swap letter ", from::binary-1, " with letter ", to::binary-1>> ->
          {:swap_letter, from, to}

        <<"rotate left ", num::binary-1, _rest::binary>> ->
          {:rotate_left, i(num)}

        <<"rotate right ", num::binary-1, _rest::binary>> ->
          {:rotate_right, i(num)}

        <<"move position ", from::binary-1, " to position ", to::binary-1>> ->
          {:move_position, i(from), i(to)}

        <<"rotate based on position of letter ", letter::binary-1>> ->
          {:rotate_position, letter}

        <<"reverse positions ", from::binary-1, " through ", to::binary-1>> ->
          {:reverse, i(from), i(to)}
      end
    end)
  end

  def i(val), do: String.to_integer(val)

  def part1_verify, do: input() |> parse_input() |> part1()
end
