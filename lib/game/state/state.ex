defmodule TicTacToe.Game.State do
  @moduledoc """
  Game State struct and methods.
  """

  @allowed_winners [:x, :o]
  @allowed_next_turn @allowed_winners

  defstruct winner: nil,
            next_turn: nil,
            finished?: false,
            started: false,
            places: nil

  @doc """
  Returns a new game State
  """
  def new(),
    do: %__MODULE__{
      places: Enum.map(1..9, fn _ -> nil end)
    }
end
