defmodule Fib do
  def fib(n) do
    {:ok, pid} = Agent.start_link(fn -> %{0 => 0, 1 => 1} end)
    val = fib(pid, n)
    Agent.stop(pid)
    val
  end

  defp fib(agent, n) do
    case Agent.get(agent, & &1[n]) do
      nil -> calc_fib(agent, n)
      val -> val
    end
  end

  defp calc_fib(agent, n) do
    val = fib(agent, n - 1) + fib(agent, n - 2)
    Agent.get_and_update(agent, fn cache -> {val, Map.put(cache, n, val)} end)
  end
end
