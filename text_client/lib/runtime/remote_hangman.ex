defmodule TextClient.Runtime.RemoteHangman do
  @remote :hangman@skybean
  def connect() do
    :rpc.call(@remote, Hangman, :new_game, [])
  end
end
