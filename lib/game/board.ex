defmodule TicTacToe.Game.Board do
  @moduledoc """
  Game board struct and methods.
  """

  alias TicTacToe.Game.State

  defstruct name: nil,
            state: nil

  @doc """
  Returns a new Board
  """
  def new(name),
    do: %__MODULE__{
      name: name,
      state: State.new(),
    }
end
