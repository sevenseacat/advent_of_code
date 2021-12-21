defmodule Y2016.Day14.Cache do
  use Agent

  # Public API
  def start(hash_fn, salt) do
    {:ok, pid} = Agent.start_link(fn -> {hash_fn, salt, Map.new()} end)
    pid
  end

  def hash(pid, index) do
    Agent.get_and_update(pid, fn {hash_fn, salt, cache} ->
      key = key(index)
      cache = Map.put_new_lazy(cache, key, fn -> hash_fn.(index, salt) end)
      {Map.get(cache, key), {hash_fn, salt, cache}}
    end)
  end

  # Private functions
  def key(index), do: Integer.to_string(index)
end
