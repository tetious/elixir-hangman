defmodule B1Web.HangmanHTML do
  use B1Web, :html

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
