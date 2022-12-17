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

  def part1(input, piece_count \\ 2022) do
    drop_piece({input, 0, map_size(input)}, {0, piece_count}, {MapSet.new(), 0})
    |> elem(1)
  end

  # @doc """
  # iex> Day17.part2("update or delete me")
  # "update or delete me"
  # """
  # def part2(input) do
  #   input
  # end

  def drop_piece(_push_data, {count, count}, state), do: state

  def drop_piece(push_data, {count, max_count}, {_grid, height} = state) do
    {push_data, state} =
      @pieces
      |> Enum.at(rem(count, @piece_count))
      |> move_to_drop_point(height)
      |> drop(push_data, state)

    drop_piece(push_data, {count + 1, max_count}, state)
  end

  defp move_to_drop_point(piece, height) do
    {offset_row, offset_col} = @drop_offset

    piece
    |> Enum.map(fn {row, col} -> {row + height + offset_row, col + offset_col} end)
  end

  defp drop(piece, {_, push_offset, _} = push_data, {grid, height}) do
    pushed_piece = maybe_push(piece, push_data, grid)
    fallen_piece = maybe_fall(pushed_piece, grid)
    push_data = put_elem(push_data, 1, push_offset + 1)

    if fallen_piece == pushed_piece do
      # At rest
      grid = Enum.reduce(pushed_piece, grid, fn x, acc -> MapSet.put(acc, x) end)
      maybe_height = Enum.max_by(pushed_piece, &elem(&1, 0)) |> elem(0)
      {push_data, {grid, max(maybe_height, height)}}
    else
      # Keep moving
      drop(fallen_piece, push_data, {grid, height})
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

  def part1_verify, do: input() |> parse_input() |> part1()
  # def part2_verify, do: input() |> parse_input() |> part2()
end
