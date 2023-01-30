defmodule B2Web.Components.Game do
  use Phoenix.Component

  @status_fields %{
    initializing: {"text-[#d883c5]", "Type or click on your first guess!"},
    good_guess: {"text-green-600", "Good guess!"},
    bad_guess: {"text-red-600", "Sorry, that letter wasn't in the word."},
    won: {"text-green-900 font-bold", "You won!"},
    lost: {"text-red-900 font-bold", "You lost. 😢"},
    already_used: {"text-[#caa]", "Oops. You already used that letter."}
  }

  @letters (?a..?z) |> Enum.map(& <<&1::utf8>>)
  def letters(), do: @letters

  attr :state, :string, required: true

  def state_name(assigns) do
    {classes, msg} = @status_fields[assigns[:state]]
    assigns = assign(assigns, classes: classes, msg: msg)
    ~H"<div class={@classes}><%= @msg %></div>"
  end

  embed_templates "game/*"
end
