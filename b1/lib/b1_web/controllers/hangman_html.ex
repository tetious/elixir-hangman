defmodule B1Web.HangmanHTML do
  use B1Web, :html
  use Phoenix.Component

  @status_fields %{
    initializing: {"text-[#d883c5]", "Guess the word, a letter at a time!"},
    good_guess: {"text-green-600", "Good guess!"},
    bad_guess: {"text-red-600", "Sorry, that letter wasn't in the word."},
    won: {"text-green-900 font-bold", "You won!"},
    lost: {"text-red-900 font-bold", "You lost. 😢"},
    already_used: {"text-[#caa]", "Oops. You already used that letter."}
  }

  attr :status, :string, required: true

  def move_status(assigns) do
    {classes, msg} = @status_fields[assigns[:status]]
    assigns = assign(assigns, classes: classes, msg: msg)
    ~H"<div class={@classes}><%= @msg %></div>"
  end

  def continue_or_try_again(%{status: status} = assigns) when status in [:won, :lost] do
    ~H"""
    <.simple_form for={:none} action={~p"/hangman"} method="post">
      <:actions>
        <.button>Try again</.button>
      </:actions>
    </.simple_form>
    """
  end

  def continue_or_try_again(assigns) do
    ~H"""
    <.simple_form :let={f} for={:make_move} action={~p"/hangman"} method="put">
      <div class="w-8">
        <.input field={{f, :guess}} label="Guess" />
      </div>
      <:actions>
        <.button class="bg-blue-600 hover:bg-blue-700">Make next guess</.button>
      </:actions>
    </.simple_form>
    """
  end

  def figure_for(0) do
    ~S{
      ┌───┐
      │   │
      O   │
     /|\  │
     / \  │
          │
    ══════╧══}
  end

  def figure_for(1) do
    ~S{
      ┌───┐
      │   │
      O   │
     /|\  │
     /    │
          │
    ══════╧══}
  end

  def figure_for(2) do
    ~S{
    ┌───┐
    │   │
    O   │
   /|\  │
        │
        │
  ══════╧══}
  end

  def figure_for(3) do
    ~s{
    ┌───┐
    │   │
    O   │
   /|   │
        │
        │
  ══════╧══}
  end

  def figure_for(4) do
    ~s{
    ┌───┐
    │   │
    O   │
    |   │
        │
        │
  ══════╧══}
  end

  def figure_for(5) do
    ~s{
    ┌───┐
    │   │
    O   │
        │
        │
        │
  ══════╧══}
  end

  def figure_for(6) do
    ~s{
    ┌───┐
    │   │
        │
        │
        │
        │
  ══════╧══}
  end

  def figure_for(7) do
    ~s{
    ┌───┐
        │
        │
        │
        │
        │
  ══════╧══}
  end

  embed_templates "hangman_html/*"
end
