defmodule B2Web.Game do
  use B2Web, :live_view
  import B2Web.Components.Game

  def mount(_params, _session, socket) do
    game = Hangman.new_game()
    tally = Hangman.tally(game)
    {:ok, socket |> assign(%{game: game, tally: tally})}
  end

  def handle_event("make_move", %{"key" => key}, socket) do
    tally = Hangman.make_move(socket.assigns.game, key) |> IO.inspect()
    {:noreply, socket |> assign(:tally, tally)}
  end

  def render(assigns) do
    ~H"""
    <div phx-window-keyup="make_move">
      <.figure tally={@tally} />
      <.alphabet tally={@tally} />
      <.word_so_far tally={@tally} />
    </div>
    """
  end
end
