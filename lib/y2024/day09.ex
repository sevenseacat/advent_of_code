defmodule Y2024.Day09 do
  use Advent.Day, no: 09

  @doc """
  iex> Day09.part1(Integer.digits(2333133121414131402))
  1928
  """
  def part1(input) do
    # This is how long the final list should be - the sum of all of the lengths of non-gaps
    finished_length = input |> Enum.take_every(2) |> Enum.sum()

    # build up the 00..111.222.. string
    list =
      input
      |> Enum.reduce({0, true, []}, fn num, {file_id, fill?, list} ->
        fill_value = if fill?, do: file_id, else: nil
        next_file_id = if fill?, do: file_id + 1, else: file_id
        list = if num == 0, do: list, else: [for(_i <- 1..num, do: fill_value) | list]
        {next_file_id, !fill?, list}
      end)
      |> elem(2)
      |> Enum.reverse()
      |> List.flatten()

    # Shorten that list and reverse it to use while backfilling
    to_use = Enum.reject(list, &(!&1)) |> Enum.reverse()

    Enum.reduce_while(list, {0, [], to_use}, fn num, {length, built, list} ->
      if length == finished_length do
        {:halt, Enum.reverse(built)}
      else
        if num do
          {:cont, {length + 1, [num | built], list}}
        else
          {:cont, {length + 1, [hd(list) | built], tl(list)}}
        end
      end
    end)
    |> Enum.reduce({0, 0}, fn num, {index, acc} ->
      {index + 1, acc + index * num}
    end)
    |> elem(1)
  end

  # @doc """
  # iex> Day09.part2("update or delete me")
  # "update or delete me"
  # """
  # def part2(input) do
  #   input
  # end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.to_integer()
    |> Integer.digits()
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  # def part2_verify, do: input() |> parse_input() |> part2()
end
