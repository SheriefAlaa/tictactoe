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
      state: State.new()
    }

  @doc """
  Render game board as ASCII.
  """
  def render({:ok, %__MODULE__{state: %State{placements: placements}}}) do
    IO.puts(
      "\n #{get_value(0, placements)} | #{get_value(1, placements)} | #{get_value(2, placements)} "
    )

    IO.puts("-----------")

    IO.puts(
      " #{get_value(3, placements)} | #{get_value(4, placements)} | #{get_value(5, placements)} "
    )

    IO.puts("-----------")

    IO.puts(
      " #{get_value(6, placements)} | #{get_value(7, placements)} | #{get_value(8, placements)} "
    )
  end

  def render({:error, error}), do: {:error, error}

  # Internal helpers
  defp get_value(index, placements) when is_integer(index) do
    case Enum.at(placements, index) do
      :x -> "X"
      :o -> "O"
      _ -> "-"
    end
  end
end
