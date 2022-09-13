defmodule Y2016.Day21 do
  use Advent.Day, no: 21

  @string "abcdefgh"
  @solution "fbgdceah"

  def part1(cmds, string \\ @string) do
    list = String.graphemes(string)

    cmds
    |> Enum.reduce(list, &run_command/2)
    |> Enum.join()
  end

  def part2(cmds, string \\ @solution) do
    list = String.graphemes(string)

    cmds
    |> Enum.reverse()
    |> Enum.reduce(list, fn cmd, list ->
      run_command(reverse_command(cmd), list)
    end)
    |> Enum.join()
  end

  defp reverse_command({:rotate_position, letter, :forward}) do
    {:rotate_position, letter, :backward}
  end

  defp reverse_command({:reverse, _, _} = reverse), do: reverse
  defp reverse_command({:rotate_left, index}), do: {:rotate_right, index}
  defp reverse_command({:rotate_right, index}), do: {:rotate_left, index}
  defp reverse_command({cmd, from, to}), do: {cmd, to, from}

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

  def run_command({:rotate_position, letter, :forward}, list) do
    index =
      case Enum.find_index(list, &(&1 == letter)) do
        index when index >= 4 -> index + 2
        index -> index + 1
      end

    run_command({:rotate_right, index}, list)
  end

  def run_command({:rotate_position, letter, :backward}, list) do
    # Find all rotations of the list, and pick the one where rotating forward
    # around the letter equals the list.
    # Find rotations by rotating right! Because multiple backwards rotations may rotate
    # forward to the same value and left picks the wrong one :(
    1..(length(list) - 1)
    |> Enum.reduce([list], fn _x, rotations ->
      [run_command({:rotate_right, 1}, hd(rotations)) | rotations]
    end)
    |> Enum.find(fn rotation ->
      run_command({:rotate_position, letter, :forward}, rotation) == list
    end)
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
          {:rotate_position, letter, :forward}

        <<"reverse positions ", from::binary-1, " through ", to::binary-1>> ->
          {:reverse, i(from), i(to)}
      end
    end)
  end

  def i(val), do: String.to_integer(val)

  def part1_verify, do: input() |> parse_input() |> part1()
  def part2_verify, do: input() |> parse_input() |> part2()
end
