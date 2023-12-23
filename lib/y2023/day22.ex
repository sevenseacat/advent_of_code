defmodule Y2023.Day22 do
  use Advent.Day, no: 22

  def part1(pieces) do
    fallen = fall(pieces)

    fallen
    |> Enum.count(fn {index, _piece} ->
      pieces = Map.delete(fallen, index)
      pieces == fall(pieces)
    end)
  end

  def part2(pieces) do
    fallen = fall(pieces)

    fallen
    |> Enum.map(fn {index, _piece} ->
      fallen
      |> Map.delete(index)
      |> fall()
      |> Enum.count(fn {index, piece} -> piece != Map.get(fallen, index) end)
    end)
    |> Enum.sum()
  end

  defp fall(pieces) do
    pieces
    |> Enum.sort_by(fn {_index, piece} -> z(piece.from) end)
    |> Enum.reduce({MapSet.new(), %{}}, &fall/2)
    |> elem(1)
  end

  defp fall({index, piece}, {cache, tower}) do
    if z(piece.from) == 0 do
      # Nowhere for it to go
      {MapSet.union(cache, piece.cubes), Map.put(tower, index, piece)}
    else
      piece =
        Enum.reduce_while(1..elem(piece.from, 2), piece, fn _, piece ->
          fallen_piece = move_down(piece)

          if Enum.all?(fallen_piece.cubes, fn cube -> !MapSet.member?(cache, cube) end) do
            # This is a valid place to fall
            {:cont, fallen_piece}
          else
            # This is not a valid place to fall
            {:halt, piece}
          end
        end)

      {MapSet.union(cache, piece.cubes), Map.put(tower, index, piece)}
    end
  end

  defp move_down(%{from: {x1, y1, z1}, to: {x2, y2, z2}, cubes: cubes}) do
    cubes = Enum.map(cubes, fn {x, y, z} -> {x, y, z - 1} end) |> MapSet.new()

    %{
      from: {x1, y1, z1 - 1},
      to: {x2, y2, z2 - 1},
      cubes: cubes
    }
  end

  @doc """
  iex> Day22.parse_input("1,0,1~1,2,1\\n0,0,2~2,0,2")
  %{0 => %{from: {1,0,1}, to: {1,2,1}, cubes: MapSet.new([{1,0,1}, {1,1,1}, {1,2,1}])},
  1 => %{from: {0,0,2}, to: {2,0,2}, cubes: MapSet.new([{0,0,2}, {1,0,2}, {2,0,2}])}}
  """
  def parse_input(input) do
    for row <- String.split(input, "\n", trim: true) do
      [x1, y1, z1, x2, y2, z2] =
        String.split(row, ["~", ","])
        |> Enum.map(&String.to_integer/1)

      cubes =
        for x <- x1..x2, y <- y1..y2, z <- z1..z2 do
          {x, y, z}
        end

      %{from: {x1, y1, z1}, to: {x2, y2, z2}, cubes: MapSet.new(cubes)}
    end
    |> Enum.with_index(fn element, index -> {index, element} end)
    |> Map.new()
  end

  defp z({_, _, z}, offset \\ 0), do: z - offset

  def part1_verify, do: input() |> parse_input() |> part1()
  def part2_verify, do: input() |> parse_input() |> part2()
end
