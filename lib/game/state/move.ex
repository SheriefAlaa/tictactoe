defmodule TicTacToe.Game.State.Move do
  @moduledoc """
  Move validation struct.
  """
  require Logger

  @allowed_symbols [:x, :o]
  @allowed_places 0..8

  defstruct place: nil,
            symbol: nil

  def validate(%__MODULE__{place: place}) when is_nil(place),
    do: {:error, :missing_place}

  def validate(%__MODULE__{symbol: symbol}) when is_nil(symbol),
    do: {:error, :missing_symbol}

  def validate(%__MODULE__{symbol: symbol}) when not is_atom(symbol),
    do: {:error, :symbol_not_atom}

  def validate(%__MODULE__{symbol: symbol}) when symbol not in @allowed_symbols,
    do: {:error, :incorrect_symbol}

  def validate(%__MODULE__{place: place} = move) do
    if !Enum.member?(@allowed_places, place) do
      {:error, :incorrect_placement}
    else
      {:ok, move}
    end
  end

  def validate(_) do
    Logger.info(
      "Usage: You should use %TicTacToe.Game.State.Move{place: #{inspect(@allowed_places)}, symbol: #{
        inspect(@allowed_symbols)
      }}"
    )

    {:error, :bad_struct}
  end
end
