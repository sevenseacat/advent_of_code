defmodule Y2018.Day17.Ground do
  use Agent

  def init(state) do
    {_min_x, min_y} = Enum.min_by(state.clay, fn {_, y} -> y end)

    Agent.start_link(fn -> {min_y, state} end)
  end

  def mark_wet(pid, {x, y}) do
    Agent.update(pid, fn {min_y, field} ->
      field =
        if y < min_y do
          field
        else
          Map.update!(field, :wet, fn wet -> MapSet.put(wet, {x, y}) end)
        end

      {min_y, field}
    end)
  end

  def fill_row(pid, {x1, y}, {x2, y}) do
    for x <- x1..x2, do: mark_water(pid, {x, y})
  end

  def wet_row(pid, {x1, y}, {x2, y}) do
    for x <- x1..x2, do: mark_wet(pid, {x, y})
  end

  def mark_water(pid, coord) do
    Agent.update(pid, fn {min_y, field} ->
      field =
        field
        |> Map.update!(:wet, fn wet -> MapSet.delete(wet, coord) end)
        |> Map.update!(:water, fn water -> MapSet.put(water, coord) end)

      {min_y, field}
    end)
  end

  def count_wet_squares(pid) do
    Agent.get(pid, fn {_, field} ->
      MapSet.size(Map.get(field, :wet)) + MapSet.size(Map.get(field, :water))
    end)
  end

  def count_water_squares(pid) do
    Agent.get(pid, fn {_, field} ->
      MapSet.size(Map.get(field, :water))
    end)
  end

  def sand?(pid, coord), do: at(pid, coord) == :sand
  def water?(pid, coord), do: at(pid, coord) == :water
  def clay?(pid, coord), do: at(pid, coord) == :clay

  defp at(pid, coord) do
    Agent.get(pid, fn {_min_y, field} ->
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

  def show_state(pid, {hi_x, hi_y} \\ {500, 0}) do
    Agent.get(
      pid,
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
