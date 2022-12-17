defmodule Y2022.Day17 do
  use Advent.Day, no: 17

  @width 7

  @pieces [
    # ####
    [{1, 1}, {1, 2}, {1, 3}, {1, 4}],

    # .#.
    # ###
    # .#.
    [{1, 2}, {2, 1}, {2, 2}, {2, 3}, {3, 2}],

    # ..#
    # ..#
    # ###
    [{1, 1}, {1, 2}, {1, 3}, {2, 3}, {3, 3}],

    # #
    # #
    # #
    # #
    [{1, 1}, {2, 1}, {3, 1}, {4, 1}],

    # ##
    # ##
    [{1, 1}, {2, 1}, {1, 2}, {2, 2}]
  ]
  @piece_count length(@pieces)
  @drop_offset {3, 2}

  def parts(input, piece_count \\ 2022) do
    # CACHING TO FIND CYCLES (to prevent iterating 1,000,000,000,000 times)
    # We track every normalized height map we see as keys in the cache
    #
    # Keys in the form %{col_no => max_height_under_overall_max_height}
    # eg.
    # |..##.#.|
    # |######.|
    # ---------   => %{1 => -1, 2 => -1, 3 => 0, 4 => 0, 5 => -1, 6 => 0, 7 => -2}
    #
    # Values in the form #%{piece_offset: index_in_pieces_list, push_offset: index_in_pushes_list,
    #   height: height, count: count}
    # So if we see the same normalized height map, and we have an entry for the same piece/push
    # offsets, then we have found a cycle and we can fast forward through a loooooot of cycles
    # (To as close as the max_count as possible)
    cache = {Map.new(), Map.new(1..7, &{&1, -1})}

    drop_piece({input, 0, map_size(input)}, {0, piece_count}, {MapSet.new(), 0}, cache)
    |> elem(1)
  end

  def drop_piece(_push_data, {count, count}, state, _cache), do: state

  def drop_piece(push_data, {count, max_count}, {grid, height}, {cache, last_seen}) do
    {push_data, {grid, height}, seen} =
      @pieces
      |> Enum.at(rem(count, @piece_count))
      |> move_to_drop_point(height)
      |> drop(push_data, {grid, height}, last_seen)

    {_, push_count, max_pushes} = push_data

    piece_offset = rem(count, @piece_count)
    push_offset = rem(push_count, max_pushes)

    normalized = normalize(seen, height)
    cache_record = Map.get(cache, normalized, [])

    if cycle_record =
         Enum.find(cache_record, fn cr ->
           cr.piece_offset == piece_offset && cr.push_offset == push_offset
         end) do
      # cycle_record is a cycle! We can now skip forward a looooot
      %{count: cycle_count, height: cycle_height} = cycle_record
      cycle_size = count - cycle_count
      multiplier = div(max_count - count, cycle_size) - 1
      new_push_data = put_elem(push_data, 1, push_offset)
      new_height = height + multiplier * (height - cycle_height)

      # We don't care about anything below the top level of the grid
      # This makes a BIG ASSUMPTION that there is no big gap that any pieces
      # could slide into, eg.
      # |....#####...|
      # |....#.......|
      # |....#.......|
      # |############|
      # If this turned out to be a problem we could duplicate the existing grid
      # and move every coordinate up by the multiplier, but don't need to
      grid =
        Enum.reduce(1..7, MapSet.new(), fn col, acc ->
          MapSet.put(acc, {new_height + Map.get(normalized, col), col})
        end)

      drop_piece(
        new_push_data,
        {multiplier * cycle_size + count + 1, max_count},
        {grid, new_height},
        {Map.new(), seen}
      )
    else
      cache_data = %{
        piece_offset: piece_offset,
        push_offset: push_offset,
        height: height,
        count: count
      }

      cache = Map.update(cache, normalized, [cache_data], &[cache_data | &1])
      drop_piece(push_data, {count + 1, max_count}, {grid, height}, {cache, seen})
    end
  end

  defp normalize(seen, height) do
    Enum.map(seen, fn {col, row} -> {col, row - height} end)
    |> Enum.into(%{})
  end

  defp move_to_drop_point(piece, height) do
    {offset_row, offset_col} = @drop_offset

    piece
    |> Enum.map(fn {row, col} -> {row + height + offset_row, col + offset_col} end)
  end

  defp drop(piece, {_, push_offset, _} = push_data, {grid, height}, last_seen) do
    pushed_piece = maybe_push(piece, push_data, grid)
    fallen_piece = maybe_fall(pushed_piece, grid)
    push_data = put_elem(push_data, 1, push_offset + 1)

    if fallen_piece == pushed_piece do
      # At rest
      grid = Enum.reduce(pushed_piece, grid, fn x, acc -> MapSet.put(acc, x) end)
      height = max(Enum.max_by(pushed_piece, &elem(&1, 0)) |> elem(0), height)

      seen =
        Enum.reduce(pushed_piece, last_seen, fn {row, col}, acc ->
          Map.update!(acc, col, fn v -> max(v, row) end)
        end)

      {push_data, {grid, height}, seen}
    else
      # Keep moving
      drop(fallen_piece, push_data, {grid, height}, last_seen)
    end
  end

  defp maybe_push(piece, {pushes, push_offset, max_push}, grid) do
    push_col = Map.get(pushes, rem(push_offset, max_push))
    new_piece = Enum.map(piece, fn {row, col} -> {row, col + push_col} end)
    revert_if_invalid(new_piece, piece, grid)
  end

  defp maybe_fall(piece, grid) do
    new_piece = Enum.map(piece, fn {row, col} -> {row - 1, col} end)
    revert_if_invalid(new_piece, piece, grid)
  end

  defp revert_if_invalid(maybe_piece, piece, grid) do
    if Enum.any?(maybe_piece, &invalid_position?(&1, grid)), do: piece, else: maybe_piece
  end

  defp invalid_position?({row, col}, grid) do
    row == 0 || col == 0 || col > @width || MapSet.member?(grid, {row, col})
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.codepoints()
    |> Enum.with_index()
    |> Map.new(fn {input, index} -> {index, if(input == ">", do: 1, else: -1)} end)
  end

  def draw_grid({grid, max_height}) do
    for(row <- max_height..1, col <- 1..7, do: char(MapSet.member?(grid, {row, col})))
    |> Enum.chunk_every(7)
    |> Enum.join("\n")
    |> IO.puts()

    {grid, max_height}
  end

  defp char(true), do: "#"
  defp char(false), do: "."

  def part1_verify, do: input() |> parse_input() |> parts()
  def part2_verify, do: input() |> parse_input() |> parts(1_000_000_000_000)
end
