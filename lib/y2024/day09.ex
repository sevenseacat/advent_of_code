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

    gap_map =
      gaps
      |> Enum.reverse()
      |> Enum.group_by(& &1.size)

    defrag(to_move, gap_map, disk)
    |> Map.values()
    |> Enum.sort_by(& &1.start_at)
    |> Enum.reduce(0, fn file, acc ->
      Enum.reduce(file.start_at..(file.start_at + file.size - 1), acc, fn index, acc ->
        acc + index * file.file_id
      end)
    end)
  end

  defp defrag([], _, disk), do: disk

  defp defrag([head | tail], gap_map, disk) do
    if gap = find_valid_gap(gap_map, head) do
      #  IO.puts("moving #{head.file_id} to #{gap.start_at}")
      leftover_gap_size = gap.size - head.size

      gap_map =
        if leftover_gap_size > 0 do
          #   IO.puts("adding new gap of size #{leftover_gap_size} at #{gap.start_at + head.size}")

          new_gap =
            gap
            |> Map.put(:size, leftover_gap_size)
            |> Map.put(:start_at, gap.start_at + head.size)

          gap_map
          |> Map.update(new_gap.size, [new_gap], fn list ->
            [new_gap | list]
            |> Enum.sort_by(& &1.start_at)
          end)
        else
          gap_map
        end
        |> Map.update!(gap.size, fn list -> tl(list) end)

      disk =
        Map.update!(disk, head.file_id, fn head ->
          %{head | start_at: gap.start_at}
        end)

      defrag(tail, gap_map, disk)
    else
      # IO.puts("can't move #{head.file_id}")
      defrag(tail, gap_map, disk)
    end
  end

  defp find_valid_gap(gap_map, %{size: min_size, start_at: max_start_at}) do
    # IO.puts("looking for gap of size #{min_size}")

    Enum.reduce(gap_map, nil, fn
      {_gap_size, []}, acc ->
        acc

      {gap_size, gaps}, acc ->
        gap = hd(gaps)

        if gap_size >= min_size && gap.start_at < max_start_at &&
             (!acc || acc.start_at > gap.start_at) do
          gap
        else
          acc
        end
    end)
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
