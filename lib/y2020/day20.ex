defmodule Y2020.Day20 do
  use Advent.Day, no: 20

  alias Y2020.Day20.Tile

  def part1(input) do
    width =
      :math.sqrt(length(input))
      |> trunc()

    # Let's brute force this thing!
    queue =
      queue_next_moves(
        PriorityQueue.new(),
        initial_states(input)
      )

    placed = do_search(PriorityQueue.pop(queue), width)

    [{0, 0}, {0, width - 1}, {width - 1, 0}, {width - 1, width - 1}]
    |> Enum.map(fn coord -> Map.fetch!(placed, coord).number end)
  end

  defp initial_states(input) do
    length = length(input)

    input
    |> Enum.flat_map(fn tile ->
      Enum.map(tile.versions, fn version ->
        %{
          placed: %{{0, 0} => %{tile | version: version, versions: []}},
          tile_pool: List.delete(input, tile),
          last: {0, 0},
          left: length - 1
        }
      end)
    end)
  end

  defp queue_next_moves(queue, states) do
    Enum.reduce(states, queue, fn state, queue ->
      PriorityQueue.push(queue, state, state.left)
    end)
  end

  defp do_search({:empty, _queue}, _width), do: raise("No winning states!")

  defp do_search({{:value, state}, queue}, width) do
    if state.tile_pool == [] do
      # Winner winner chicken dinner.
      state.placed
    else
      # Calculate legal moves, record seen, etc.
      next_level = possible_tile_placements(state, width)
      do_search(PriorityQueue.pop(queue_next_moves(queue, next_level)), width)
    end
  end

  defp possible_tile_placements(
         %{placed: placed, tile_pool: tile_pool, last: last, left: left},
         width
       ) do
    %{next: next, checks: checks} = next(last, width)

    # Check everything in the tile pool against the placed tiles for the positions
    # we need to check
    tile_pool
    |> Enum.flat_map(fn tile ->
      Enum.map(tile.versions, fn version ->
        %{tile | version: version, versions: []}
      end)
    end)
    |> Enum.filter(fn tile ->
      run_checks(placed, tile, checks)
    end)
    |> Enum.map(fn tile ->
      %{
        placed: Map.put(placed, next, tile),
        tile_pool: Enum.reject(tile_pool, fn tp -> tp.number == tile.number end),
        last: next,
        left: left - 1
      }
    end)
  end

  # Which tile position are we placing next, and which tile positions do we need
  # to verify it against?
  defp next({row, col}, width) do
    if col + 1 == width do
      %{next: {row + 1, 0}, checks: [{row, 0, :bottom_edge, :top_edge}]}
    else
      if row == 0 do
        %{next: {row, col + 1}, checks: [{row, col, :right_edge, :left_edge}]}
      else
        %{
          next: {row, col + 1},
          checks: [
            {row, col, :right_edge, :left_edge},
            {row - 1, col + 1, :bottom_edge, :top_edge}
          ]
        }
      end
    end
  end

  defp run_checks(placed, maybe_tile, checks) do
    Enum.all?(checks, fn {row, col, side, to_check} ->
      placed_tile = Map.fetch!(placed, {row, col})
      Map.fetch!(placed_tile.version, side) == Map.fetch!(maybe_tile.version, to_check)
    end)
  end

  # @doc """
  # iex> Day20.part2("update or delete me")
  # "update or delete me"
  # """
  # def part2(input) do
  #   input
  # end

  def parse_input(input) do
    input
    |> String.split("\n\n", trim: true)
    |> Enum.map(&parse_tile/1)
  end

  defp parse_tile(input) do
    [number | content] = String.split(input, "\n")

    [_, number] = Regex.run(~r/Tile (\d+):/, number)
    content = Enum.map(content, &String.graphemes/1)

    %Tile{
      number: String.to_integer(number),
      version: nil,
      versions: Tile.generate_versions(content)
    }
  end

  def part1_verify, do: input() |> parse_input() |> part1() |> Enum.product()
  # def part2_verify, do: input() |> parse_input() |> part2()
end
