defmodule Y2017.Day13.Layer do
  alias __MODULE__

  defstruct range: nil, position: 0, caught: false, dir: :down

  def new([depth, range]) do
    {String.to_integer(depth), %Layer{range: String.to_integer(range)}}
  end

  def move_sentry(%Layer{range: range, position: pos, dir: dir} = layer) do
    new_pos = move(pos, dir)

    {dir, new_pos} =
      case end_of_range?(range, new_pos) do
        true ->
          dir = change_dir(dir)
          {dir, move(pos, dir)}

        false ->
          {dir, new_pos}
      end

    %{layer | dir: dir, position: new_pos}
  end

  defp move(pos, :down), do: pos + 1
  defp move(pos, :up), do: pos - 1

  defp end_of_range?(range, new_pos), do: new_pos < 0 || new_pos == range

  defp change_dir(:down), do: :up
  defp change_dir(:up), do: :down
end
