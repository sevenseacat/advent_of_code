defmodule Y2016.Day14.Cache do
  use GenServer

  # Public API
  def start do
    {:ok, pid} = GenServer.start_link(__MODULE__, nil)
    pid
  end

  def hash(pid, index, salt, func) do
    GenServer.call(pid, {:hash, index, salt, func})
  end

  # Callbacks
  def init(_), do: {:ok, %{}}

  def handle_call({:hash, index, salt, func}, _, cache) do
    cache = Map.put_new_lazy(cache, key(index), fn -> func.(index, salt) end)

    {:reply, Map.get(cache, key(index)), cache}
  end

  # Private functions
  def key(index), do: Integer.to_string(index)
end