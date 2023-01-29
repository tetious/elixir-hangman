defmodule B1Web.HangmanController do
  use B1Web, :controller

  def index(conn, _params) do
    render(conn, :index)
  end

  def new(conn, _params) do
    game = Hangman.new_game()
    tally = Hangman.tally(game)

    conn
    |> put_session(:game, game)
    |> render(:game, tally: tally)
  end

  def update(conn, params) do
    guess = params["make_move"]["guess"]
    game = get_session(conn, :game)
    tally = Hangman.make_move(game, guess)
    render(conn, :game, tally: tally)
  end
end
