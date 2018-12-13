defmodule Y2018.Day13 do
  use Advent.Day, no: 13

  def part1(input) do
    input
    |> parse_input
    |> run_until_crash(0)
  end

  def part2(input) do
    input
    |> parse_input
    |> run_removing_crashes(0)
  end

  def run_until_crash(input, tick) do
    output = tick(input)

    case crashed?(output) do
      nil -> run_until_crash(output, tick + 1)
      result -> result
    end
  end

  def run_removing_crashes(input, tick) do
    output = tick(input) |> remove_crashes

    case find_carts(output) do
      [cart] -> cart
      _ -> run_removing_crashes(output, tick + 1)
    end
  end

  def tick(grid) do
    grid
    |> find_carts
    |> Enum.sort_by(fn {coord, _} -> coord end)
    |> Enum.reduce(grid, fn cart, grid -> move(grid, cart) end)
  end

  defp find_carts(grid) do
    Enum.filter(grid, fn {_coord, {_track, cart}} -> cart != nil end)
  end

  defp move(grid, {coord, {_, {facing, next_turn}}}) do
    # This cart may have been crashed since the start of the tick.
    {_, carts} = Map.get(grid, coord)

    if is_list(carts) do
      # If so, it cannot move.
      grid
    else
      # It can move. I like to move it move it
      new_coord = move_coord(coord, facing)
      track_at_new_coord = Map.get(grid, new_coord) |> elem(0)
      new_facing = turn(facing, track_at_new_coord, next_turn)
      new_turn = if track_at_new_coord == "+", do: next_turn(next_turn), else: next_turn
      new_cart = {new_facing, new_turn}

      grid
      |> Map.update!(coord, fn {track, _} -> {track, nil} end)
      |> Map.update!(new_coord, fn {track, cart} ->
        if cart == nil do
          {track, new_cart}
        else
          {track, [new_cart, cart | []]}
        end
      end)
    end
  end

  defp move_coord({x, y}, :left), do: {x - 1, y}
  defp move_coord({x, y}, :right), do: {x + 1, y}
  defp move_coord({x, y}, :up), do: {x, y - 1}
  defp move_coord({x, y}, :down), do: {x, y + 1}

  defp turn(:right, "/", _), do: :up
  defp turn(:right, "\\", _), do: :down

  defp turn(:up, "/", _), do: :right
  defp turn(:up, "\\", _), do: :left

  defp turn(:down, "/", _), do: :left
  defp turn(:down, "\\", _), do: :right

  defp turn(:left, "/", _), do: :down
  defp turn(:left, "\\", _), do: :up

  defp turn(:up, "+", :straight), do: :up
  defp turn(:up, "+", next_turn), do: next_turn
  defp turn(:down, "+", :left), do: :right
  defp turn(:down, "+", :right), do: :left
  defp turn(:left, "+", :left), do: :down
  defp turn(:left, "+", :right), do: :up
  defp turn(:right, "+", :left), do: :up
  defp turn(:right, "+", :right), do: :down
  defp turn(facing, _, _), do: facing

  defp next_turn(:left), do: :straight
  defp next_turn(:straight), do: :right
  defp next_turn(:right), do: :left

  def crashed?(input) do
    Enum.find(input, fn {_, {_, carts}} -> is_list(carts) end)
  end

  def remove_crashes(input) do
    input
    |> Enum.map(fn {coord, {track, carts}} ->
      carts = if is_list(carts), do: nil, else: carts
      {coord, {track, carts}}
    end)
    |> Enum.into(%{})
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.reduce(%{}, &parse_row/2)
  end

  defp parse_row({row, num}, grid) do
    row
    |> String.graphemes()
    |> Enum.reduce({grid, 0}, fn char, {grid, col} ->
      {add_char_to_grid(grid, char, {col, num}), col + 1}
    end)
    |> elem(0)
  end

  defp add_char_to_grid(grid, char, {col, row}) do
    val =
      case char do
        " " -> nil
        "^" -> {"|", {:up, :left}}
        "v" -> {"|", {:down, :left}}
        "<" -> {"-", {:left, :left}}
        ">" -> {"-", {:right, :left}}
        c -> {c, nil}
      end

    if val != nil do
      Map.put(grid, {col, row}, val)
    else
      grid
    end
  end

  def part1_verify, do: input() |> part1() |> elem(0)
  def part2_verify, do: input() |> part2() |> elem(0)
end
