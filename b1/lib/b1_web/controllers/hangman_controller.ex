defmodule B1Web.HangmanController do
  use B1Web, :controller

  def index(conn, _params) do
    render(conn, :index)
  end

  def new(conn, _params) do
    game = Hangman.new_game()

    conn
    |> put_session(:game, game)
    |> redirect(to: ~p"/hangman/current")
  end

  def update(conn, params) do
    guess = params["make_move"]["guess"]
    conn |> get_session(:game) |> Hangman.make_move(guess)
    redirect(conn, to: ~p"/hangman/current")
  end

  def show(conn, _param) do
    tally = conn |> get_session(:game) |> Hangman.tally()
    render(conn, :game, tally: tally)
  end
end
