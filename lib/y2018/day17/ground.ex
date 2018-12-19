defmodule Y2018.Day17.Ground do
  use Agent

  def init(state) do
    {_min_x, min_y} = Enum.min_by(state.clay, fn {_, y} -> y end)

    Agent.start_link(fn -> {min_y, state} end, name: __MODULE__)
  end

  def kill do
    Agent.stop(__MODULE__)
  end

  def mark_wet({x, y}) do
    Agent.update(__MODULE__, fn {min_y, field} ->
      field =
        if y < min_y do
          field
        else
          Map.update!(field, :wet, fn wet -> MapSet.put(wet, {x, y}) end)
        end

      {min_y, field}
    end)
  end

  def fill_row({x1, y}, {x2, y}) do
    for x <- x1..x2, do: mark_water({x, y})
  end

  def wet_row({x1, y}, {x2, y}) do
    for x <- x1..x2, do: mark_wet({x, y})
  end

  def mark_water(coord) do
    Agent.update(__MODULE__, fn {min_y, field} ->
      field =
        field
        |> Map.update!(:wet, fn wet -> MapSet.delete(wet, coord) end)
        |> Map.update!(:water, fn water -> MapSet.put(water, coord) end)

      {min_y, field}
    end)
  end

  def count_wet_squares() do
    Agent.get(__MODULE__, fn {_, field} ->
      MapSet.size(Map.get(field, :wet)) + MapSet.size(Map.get(field, :water))
    end)
  end

  def sand?(coord), do: at(coord) == :sand
  def water?(coord), do: at(coord) == :water
  def clay?(coord), do: at(coord) == :clay

  defp at(coord) do
    Agent.get(__MODULE__, fn {_min_y, field} ->
      if MapSet.member?(field.clay, coord) do
        :clay
      else
        if MapSet.member?(field.water, coord) do
          :water
        else
          :sand
        end
      end
    end)
  end

  def show_state({hi_x, hi_y} \\ {500, 0}) do
    Agent.get(
      __MODULE__,
      fn {_min_y, field} ->
        {{_min_x, min_y}, {_max_x, max_y}} =
          field |> Map.get(:clay) |> Enum.min_max_by(fn {_, y} -> y end)

        {{min_x, _min_y}, {max_x, _max_y}} =
          field |> Map.get(:clay) |> Enum.min_max_by(fn {x, _} -> x end)

        Enum.each((min_y - 1)..(max_y + 1), fn y ->
          Enum.reduce((min_x - 1)..(max_x + 1), [], fn x, acc ->
            char =
              if x == hi_x && y == hi_y do
                "█"
              else
                if MapSet.member?(field.clay, {x, y}) do
                  "#"
                else
                  if MapSet.member?(field.water, {x, y}) do
                    "~"
                  else
                    if MapSet.member?(field.wet, {x, y}) do
                      "|"
                    else
                      " "
                    end
                  end
                end
              end

            [char | acc]
          end)
          |> Enum.reverse()
          |> List.to_string()
          |> IO.puts()
        end)
      end,
      20000
    )
  end
end
