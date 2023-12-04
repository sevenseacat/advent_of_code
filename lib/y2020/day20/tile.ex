defmodule Y2020.Day20.Tile do
  alias Y2020.Day20.TileVersion

  defstruct [:number, :version, :versions]

  def count_matching_edges(tile, tiles) do
    tile.edges
    |> Enum.filter(fn edge ->
      Enum.any?(tiles, fn maybe_tile ->
        tile.number != maybe_tile.number && Enum.member?(maybe_tile.edges, edge)
      end)
    end)
    |> Enum.count()
    |> dbg
  end

  def generate_versions(content) do
    transposed = Advent.transpose(content)
    reversed = Enum.reverse(content)

    # eg. content = [[1,2,3], [4,5,6], [7,8,9]]
    [
      # [[1,2,3], [4,5,6], [7,8,9]]
      content,
      # [[7,4,1], [8,5,2], [9,6,3]] rotated right
      reversed |> Advent.transpose(),
      # [[9,8,7], [6,5,4], [3,2,1]] rotated right again
      content |> Enum.reverse() |> Enum.map(&Enum.reverse/1),
      # [[3,6,9], [2,5,8], [1,4,7]] rotated right again
      transposed |> Enum.reverse(),
      # [[3,2,1], [6,5,4], [9,8,7]] original flipped
      transposed |> Enum.reverse() |> Advent.transpose(),
      # [[9,6,3], [8,5,2], [7,4,1]] rotated right
      reversed |> Advent.transpose() |> Enum.reverse(),
      # [[7,8,9], [4,5,6], [1,2,3]] rotated right again
      reversed,
      # [[1,4,7], [2,5,8], [3,6,9]] rotated right again
      transposed
    ]
    |> Enum.map(&TileVersion.new/1)
  end
end

defmodule Y2020.Day20.TileVersion do
  defstruct [:content, :left_edge, :right_edge, :top_edge, :bottom_edge]

  def new(content) do
    %__MODULE__{
      content: content,
      left_edge: Enum.map(content, &List.first/1),
      right_edge: Enum.map(content, &List.last/1),
      top_edge: List.first(content),
      bottom_edge: List.last(content)
    }
  end
end
