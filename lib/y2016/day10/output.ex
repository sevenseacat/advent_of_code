defmodule Y2016.Day10.Output do
  use GenServer

  # Public methods

  def new(number) do
    GenServer.start_link(__MODULE__, nil, name: via_tuple(number))
  end

  # Callbacks

  def init(_), do: {:ok, []}

  def handle_call({:take_piece, piece}, _from, pieces) do
    {:reply, :ok, [piece | pieces]}
  end

  # Private methods

  defp via_tuple(id) when is_tuple(id), do: {:via, :gproc, id}
  defp via_tuple(id), do: {:via, :gproc, gproc_key(id)}

  defp gproc_key(id), do: {:n, :l, {:output, id}}
end
