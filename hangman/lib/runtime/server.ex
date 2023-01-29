defmodule Hangman.Runtime.Server do
  alias Hangman.Impl.Game
  alias Hangman.Runtime.Watchdog
  use GenServer

  @type t :: pid
  # 1 hour
  @idle_timeout 1 * 60 * 60 * 1000

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil)
  end

  def init(_) do
    {:ok, {Game.new_game(), Watchdog.start(@idle_timeout)}}
  end

  def handle_call({:make_move, guess}, _from, {game, watcher}) do
    Watchdog.pet(watcher)
    {game, tally} = Game.make_move(game, guess)
    {:reply, tally, game}
  end

  def handle_call({:tally}, _from, {game, watcher}) do
    Watchdog.pet(watcher)
    {:reply, Game.tally(game), game}
  end
end
