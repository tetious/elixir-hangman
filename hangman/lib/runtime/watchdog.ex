defmodule Hangman.Runtime.Watchdog do
  def start(expiry_time) do
    spawn_link(fn -> watcher(expiry_time) end)
  end

  def pet(watcher) do
    send(watcher, :good_dog)
  end

  defp watcher(expiry_time) do
    receive do
      :good_dog ->
        watcher(expiry_time)
    after
      expiry_time ->
        Process.exit(self(), {:shutdown, :watchdog_triggered})
    end
  end
end
