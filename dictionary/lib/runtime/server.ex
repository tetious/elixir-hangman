defmodule Dictionary.Runtime.Server do
  alias Dictionary.Impl.WordList
  @me __MODULE__
  @type t :: pid

  def start_link(), do: Agent.start_link(&WordList.word_list/0, name: @me)
  def random_word(), do: Agent.get(@me, &WordList.random_word/1)
end
