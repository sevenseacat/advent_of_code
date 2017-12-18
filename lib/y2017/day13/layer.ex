defmodule Y2017.Day13.Layer do
  alias __MODULE__

  defstruct range: nil, position: 0, caught: false

  def new([depth, range]) do
    {String.to_integer(depth), %Layer{range: String.to_integer(range)}}
  end

  def set_position(%Layer{range: range} = layer, offset) do
    # Remove loops in the process, ie. if offset is 8 and range is 3, then the offset can be reduced
    # by 4 because after 4 moves, the sentry will be back at its starting position
    offset = rem(offset, range * 2 - 2)
    new_pos = if offset >= range, do: offset - 2 - 2 * (offset - range), else: offset

    %{layer | position: new_pos}
  end
end
