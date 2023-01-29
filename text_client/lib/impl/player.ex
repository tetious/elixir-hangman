defmodule TextClient.Impl.Player do
  @typep state :: {Hangman.game(), Hangman.tally()}
  def start() do
    game = Hangman.new_game()
    tally = Hangman.tally(game)
    interact({game, tally})
  end

  @spec interact(state) :: :ok

  def interact({_game, _tally = %{game_state: :won}}) do
    IO.puts("Congrats! You won!")
  end

  def interact({_game, tally = %{game_state: :lost}}) do
    IO.puts("Sorry, you lost. :( The word was #{tally.letters |> Enum.join()}")
  end

  def interact({game, tally}) do
    feedback_for(tally) |> IO.puts()
    current_word(tally) |> IO.puts()
    tally = Hangman.make_move(game, get_guess())
    interact({game, tally})
  end

  defp get_guess() do
    IO.gets("Next letter: ")
    |> String.trim()
    |> String.downcase()
  end

  defp current_word(tally) do
    [
      "Word so far: ",
      tally.letters |> Enum.join(" "),
      "\tturns left: ",
      tally.turns_left |> to_string(),
      "\tused so far: ",
      tally.used |> Enum.join(",")
    ]
  end

  defp feedback_for(tally = %{game_state: :initializing}) do
    "Welcome! I'm thinking of a #{tally.letters |> length()} letter word"
  end

  defp feedback_for(_tally = %{game_state: :good_guess}),
    do: "Good guess!"

  defp feedback_for(_tally = %{game_state: :bad_guess}),
    do: "Sorry, that letter's not in the word."

  defp feedback_for(_tally = %{game_state: :already_used}),
    do: "You already used that letter."
end
