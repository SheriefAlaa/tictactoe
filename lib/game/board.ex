defmodule TicTacToe.Game.Board do
  @moduledoc """
  Game board struct and methods.
  """

  defstruct winner: nil,
            next_turn: nil,
            finished?: false,
            started: false,
            places: nil

  @doc """
  Returns a new Board
  """
  def new(),
    do: %__MODULE__{
      places: Enum.map(1..9, fn _ -> nil end)
    }
end
