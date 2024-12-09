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

  @doc """
  iex> Day09.part2(Integer.digits(2333133121414131402))
  2858
  """
  def part2(input) do
    list =
      input
      |> Enum.reduce({0, 0, true, []}, fn size, {file_id, start_at, fill?, list} ->
        type = if fill?, do: :fill, else: :gap

        {file_id + 0.5, start_at + size, !fill?,
         [%{type: type, start_at: start_at, file_id: file_id, size: size} | list]}
      end)
      |> elem(3)
      |> Enum.reject(&(&1.size == 0))
      |> Enum.map(fn row -> Map.update!(row, :file_id, &trunc/1) end)

    {to_move, gaps} = Enum.split_with(list, &(&1.type == :fill))
    disk = Map.new(list, &{&1.file_id, &1})
    gaps = Enum.reverse(gaps)

    defrag(to_move, gaps, [], disk)
    |> Map.values()
    |> Enum.sort_by(& &1.start_at)
    |> Enum.reduce(0, fn file, acc ->
      Enum.reduce(file.start_at..(file.start_at + file.size - 1), acc, fn index, acc ->
        acc + index * file.file_id
      end)
    end)
  end

  defp defrag([], _, _, disk), do: disk

  defp defrag([_head | tail], [], gaps, disk), do: defrag(tail, Enum.reverse(gaps), [], disk)

  defp defrag([head | tail], [head_gap | tail_gaps], start_gaps, disk) do
    if head.start_at < head_gap.start_at do
      # IO.puts("can't move #{head.file_id}")
      defrag(tail, Enum.reverse(start_gaps) ++ [head_gap | tail_gaps], [], disk)
    else
      if head_gap.size >= head.size do
        # IO.puts("gonna move #{head.file_id} to #{head_gap.start_at}")
        leftover_gap_size = head_gap.size - head.size

        gaps =
          if leftover_gap_size > 0 do
            new_gap =
              head_gap
              |> Map.put(:size, leftover_gap_size)
              |> Map.put(:start_at, head_gap.start_at + head.size)

            Enum.reverse(start_gaps) ++ [new_gap | tail_gaps]
          else
            Enum.reverse(start_gaps) ++ tail_gaps
          end

        disk =
          Map.update!(disk, head.file_id, fn head ->
            %{head | start_at: head_gap.start_at}
          end)

        defrag(tail, gaps, [], disk)
      else
        defrag([head | tail], tail_gaps, [head_gap | start_gaps], disk)
      end
    end
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.to_integer()
    |> Integer.digits()
  end

  def part1_verify, do: input() |> parse_input() |> part1()
  def part2_verify, do: input() |> parse_input() |> part2()
end
