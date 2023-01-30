defmodule MemoryWeb.MemoryDisplay do
  use MemoryWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, tick_and_update(socket)}
  end

  def handle_info(:tick, socket) do
    {:noreply, tick_and_update(socket)}
  end

  defp tick_and_update(socket) do
    Process.send_after(self(), :tick, 1000)
    assign(socket, :memory, :erlang.memory())
  end

  def render(assigns) do
    ~H"""
    <div class="grid grid-cols-2">
      <%= for { name, value} <- @memory do %>
        <div class="font-bold"><%= name %></div>
        <div><%= value %></div>
      <% end %>
    </div>
    """
  end
end
