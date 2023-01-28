defmodule Hangman.Impl.Game do
  alias Hangman.Type

  @type t :: %__MODULE__{
          turns_left: integer,
          game_state: Type.state(),
          letters: list(String.t()),
          used: MapSet.t(String.t())
        }
  defstruct turns_left: 7, game_state: :initializing, letters: [], used: MapSet.new()

  @spec new_game :: t()
  def new_game do
    new_game(Dictionary.random_word())
  end

  @spec new_game(String.t()) :: t()
  def new_game(word) do
    %__MODULE__{
      letters: word |> String.codepoints()
    }
  end

  @spec make_move(t, String.t()) :: {t, Type.tally()}
  def make_move(_game, <<l::8, _::binary>> = guess)
      when byte_size(guess) != 1 or l not in 97..122 do
    raise ArgumentError, "guess must be a single lowercase letter"
  end

  def make_move(game = %{game_state: state}, _guess) when state in [:won, :lost],
    do: game |> return_with_tally()

  def make_move(game, guess) do
    accept_guess(game, guess, MapSet.member?(game.used, guess))
    |> return_with_tally()
  end

  defp accept_guess(game, _guess, _already_used = true),
    do: %{game | game_state: :already_used}

  defp accept_guess(game, guess, _not_already_used) do
    %{game | used: MapSet.put(game.used, guess)}
    |> score_guess(Enum.member?(game.letters, guess))
  end

  defp score_guess(game, _good_guess = true) do
    won = game.letters |> MapSet.new() |> MapSet.subset?(game.used)
    %{game | game_state: if(won, do: :won, else: :good_guess)}
  end

  defp score_guess(game = %{turns_left: 1}, _bad_guess) do
    %{game | game_state: :lost, turns_left: 0}
  end

  defp score_guess(game, _bad_guess) do
    %{game | game_state: :bad_guess, turns_left: game.turns_left - 1}
  end

  def tally(game) do
    %{
      turns_left: game.turns_left,
      game_state: game.game_state,
      letters: reveal_guessed_letters(game),
      used: game.used |> MapSet.to_list() |> Enum.sort()
    }
  end

  defp reveal_guessed_letters(game = %{game_state: :lost}), do: game.letters

  defp reveal_guessed_letters(game) do
    game.letters |> Enum.map(&(MapSet.member?(game.used, &1) |> maybe_reveal(&1)))
  end

  defp maybe_reveal(true, letter), do: letter
  defp maybe_reveal(_, _letter), do: "_"

  defp return_with_tally(game), do: {game, tally(game)}
end
