defmodule Y2016.Day10.Output do
  use GenServer

  # Public methods

  def new(number) do
    GenServer.start_link(__MODULE__, nil, name: via_tuple(number))
  end

  # Multiply the values in certain outputs together for part 2.
  def output_product([]), do: 1

  def output_product([bucket_no | bucket_nos]) do
    GenServer.call(via_tuple(bucket_no), :chip_value) * output_product(bucket_nos)
  end

  # Callbacks

  def init(_), do: {:ok, []}

  def handle_call({:take_piece, piece}, _from, pieces) do
    {:reply, :ok, [piece | pieces]}
  end

  def handle_call(:chip_value, _from, pieces) when length(pieces) != 1 do
    {:stop, {:error, :incorrect_chip_count}, pieces}
  end

  def handle_call(:chip_value, _from, [piece]), do: {:reply, piece, [piece]}

  # Private methods

  defp via_tuple(id) when is_tuple(id), do: {:via, :gproc, id}
  defp via_tuple(id), do: {:via, :gproc, gproc_key(id)}

  defp gproc_key(id), do: {:n, :l, {:output, id}}
end
