defmodule HangmanImplGameTest do
  alias Hangman.Impl.Game
  use ExUnit.Case

  test "new game returns structure" do
    game = Game.new_game()

    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert length(game.letters) > 0
  end

  test "new game returns correct word" do
    game = Game.new_game("wombat")
    assert game.letters == "wombat" |> String.codepoints()
  end

  test "letters are [a-z]" do
    game = Game.new_game()
    assert Enum.join(game.letters) =~ ~r/[a-z]/
  end

  test "state doesn't change if a game is won or lost" do
    for state <- [:won, :lost] do
      game = Game.new_game("wombat")
      game = %{game | game_state: state}
      assert {^game, _tally} = Game.make_move(game, "x")
    end
  end

  test "a duplicate letter is reported" do
    game = Game.new_game()
    {game, _} = Game.make_move(game, "x")
    assert game.game_state != :already_used
    {game, _} = Game.make_move(game, "y")
    assert game.game_state != :already_used
    {game, _} = Game.make_move(game, "x")
    assert game.game_state == :already_used
  end

  test "we record letters used" do
    game = Game.new_game()
    {game, _} = Game.make_move(game, "x")
    {game, _} = Game.make_move(game, "y")
    {game, _} = Game.make_move(game, "x")
    assert MapSet.equal?(game.used, MapSet.new(["x", "y"]))
  end

  test "we recognize a good guess" do
    game = Game.new_game("wombat")
    {_game, tally} = Game.make_move(game, "m")
    assert tally.game_state == :good_guess
    {_game, tally} = Game.make_move(game, "t")
    assert tally.game_state == :good_guess
  end

  test "we recognize a bad guess" do
    game = Game.new_game("wombat")
    {_game, tally} = Game.make_move(game, "g")
    assert tally.game_state == :bad_guess
    {_game, tally} = Game.make_move(game, "t")
    assert tally.game_state == :good_guess
    {_game, tally} = Game.make_move(game, "z")
    assert tally.game_state == :bad_guess
  end

  test "can handle a sequence of moves" do
    [
      {"a", :bad_guess, 6, ["_", "_", "_", "_", "_"], ["a"]},
      {"a", :already_used, 6, ["_", "_", "_", "_", "_"], ["a"]},
      {"e", :good_guess, 6, ["_", "e", "_", "_", "_"], ["a", "e"]},
      {"x", :bad_guess, 5, ["_", "e", "_", "_", "_"], ["a", "e", "x"]}
    ]
    |> test_sequence_of_moves("hello")
  end

  test "can handle a winning game" do
    [
      {"a", :bad_guess, 6, ["_", "_", "_", "_", "_"], ["a"]},
      {"a", :already_used, 6, ["_", "_", "_", "_", "_"], ["a"]},
      {"e", :good_guess, 6, ["_", "e", "_", "_", "_"], ["a", "e"]},
      {"x", :bad_guess, 5, ["_", "e", "_", "_", "_"], ["a", "e", "x"]},
      {"l", :good_guess, 5, ["_", "e", "l", "l", "_"], ["a", "e", "x", "l"]},
      {"o", :good_guess, 5, ["_", "e", "l", "l", "o"], ["a", "e", "x", "l", "o"]},
      {"z", :bad_guess, 4, ["_", "e", "l", "l", "o"], ["a", "e", "x", "l", "o", "z"]},
      {"h", :won, 4, ["h", "e", "l", "l", "o"], ["a", "e", "x", "l", "o", "z", "h"]}
    ]
    |> test_sequence_of_moves("hello")
  end

  test "can handle a losing game" do
    [
      {"a", :bad_guess, 6, ["_", "_", "_", "_", "_"], ["a"]},
      {"a", :already_used, 6, ["_", "_", "_", "_", "_"], ["a"]},
      {"e", :good_guess, 6, ["_", "e", "_", "_", "_"], ["a", "e"]},
      {"x", :bad_guess, 5, ["_", "e", "_", "_", "_"], ["a", "e", "x"]},
      {"l", :good_guess, 5, ["_", "e", "l", "l", "_"], ["a", "e", "x", "l"]},
      {"o", :good_guess, 5, ["_", "e", "l", "l", "o"], ["a", "e", "x", "l", "o"]},
      {"z", :bad_guess, 4, ["_", "e", "l", "l", "o"], ["a", "e", "x", "l", "o", "z"]},
      {"y", :bad_guess, 3, ["_", "e", "l", "l", "o"], ["a", "e", "x", "l", "o", "z", "y"]},
      {"w", :bad_guess, 2, ["_", "e", "l", "l", "o"], ["a", "e", "x", "l", "o", "z", "y", "w"]},
      {"q", :bad_guess, 1, ["_", "e", "l", "l", "o"], ["a", "e", "x", "l", "o", "z", "y", "w", "q"]},
      {"u", :lost, 0, ["_", "e", "l", "l", "o"], ["a", "e", "x", "l", "o", "z", "u", "y", "w", "q" ]},
    ]
    |> test_sequence_of_moves("hello")
  end

  defp test_sequence_of_moves(script, target) do
    game = Game.new_game(target)
    Enum.reduce(script, game, &check_one_move/2)
  end

  defp check_one_move({guess, state, turns, letters, used}, game) do
    {game, tally} = Game.make_move(game, guess)
    assert tally.game_state == state
    assert tally.turns_left == turns
    assert tally.letters == letters
    assert tally.used == Enum.sort(used)
    game
  end
end
