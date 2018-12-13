defmodule Y2018.Day13.Cart do
  alias __MODULE__

  defstruct [:id, :direction, :next_turn, :coordinates, :crashed]

  def move_forward(%Cart{} = cart) do
    %{cart | coordinates: move(cart.coordinates, cart.direction)}
  end

  def turn(%Cart{} = cart, track) do
    %{
      cart
      | direction: turn(cart.direction, track, cart.next_turn),
        next_turn: next_turn(cart.next_turn, track)
    }
  end

  defp move({x, y}, :left), do: {x - 1, y}
  defp move({x, y}, :right), do: {x + 1, y}
  defp move({x, y}, :up), do: {x, y - 1}
  defp move({x, y}, :down), do: {x, y + 1}

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

  defp next_turn(:left, "+"), do: :straight
  defp next_turn(:straight, "+"), do: :right
  defp next_turn(:right, "+"), do: :left
  defp next_turn(turn, _), do: turn
end
