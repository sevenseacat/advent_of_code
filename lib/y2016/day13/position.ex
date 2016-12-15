defmodule Y2016.Day13.Position do
  def initial, do: [1, 1]

  @doc """
  iex> Position.wall?([0, 0], 10)
  false

  iex> Position.wall?([0, 2], 10)
  true

  iex> Position.wall?([6, 1], 10)
  false

  iex> Position.wall?([3, 5], 10)
  true
  """
  def wall?([x, y], magic_number) do
    val =
      (x * x + 3 * x + 2 * x * y + y + y * y + magic_number)
      |> Integer.digits(2)
      |> Enum.count(&(&1 == 1))
      |> rem(2)

    val == 1
  end

  def winning?(current, destination), do: current == destination

  @doc """
  iex> Position.legal_moves([0, 0], 10)
  [[0, 1]]

  iex> Position.legal_moves([2, 2], 10)
  [[1, 2], [3, 2]]
  """
  def legal_moves([x, y], magic_number) do
    [[x - 1, y], [x + 1, y], [x, y - 1], [x, y + 1]]
    |> Enum.reject(fn [x, y] -> x < 0 || y < 0 end)
    |> Enum.reject(fn position -> wall?(position, magic_number) end)
  end
end
