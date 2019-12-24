defmodule TicTacToe.Game.State do
  @moduledoc """
  Game State struct and methods.
  """

  alias TicTacToe.Game.State.Move

  @allowed_winners [:x, :o]

  @combos [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 4, 8],
    [2, 4, 6],
    [0, 3, 6],
    [2, 5, 8],
    [1, 4, 7]
  ]

  defstruct winner: nil,
            next_turn: nil,
            finished?: false,
            placements: nil

  @doc """
  Returns a new game State
  """
  def new(),
    do: %__MODULE__{
      placements: Enum.map(1..9, fn _ -> nil end)
    }

  @doc """
  Adds the next move to the game state and also the next valid turn.
  """
  def add_move({:ok, %Move{symbol: this_turn}}, %__MODULE__{next_turn: next_turn})
      when not is_nil(next_turn) and this_turn != next_turn,
      do: {:error, :not_your_turn}

  def add_move({:ok, %Move{} = move}, %__MODULE__{placements: placements} = state) do
    {target_place, _} = List.pop_at(placements, move.place)

    if is_nil(target_place) do
      placements = List.replace_at(placements, move.place, move.symbol)
      {:ok, %{state | placements: placements, next_turn: add_next_turn(move)}}
    else
      {:error, :already_played}
    end
  end

  def add_move({:error, _} = move_error, _), do: move_error

  def add_won({:ok, %__MODULE__{placements: placements} = state}) do
    found_combo =
      Enum.find(@combos, [], fn combo ->
        Enum.all?(combo, &(Enum.at(placements, &1) == hd(@allowed_winners))) ||
          Enum.all?(combo, &(Enum.at(placements, &1) == List.last(@allowed_winners)))
      end)

    case found_combo do
      [] ->
        {:ok, state}

      won_combo ->
        {winner, _} = List.pop_at(placements, hd(won_combo))
        {:ok, %{state | winner: winner, finished?: true}}
    end
  end

  def add_won({:error, _} = error), do: error

  def all_placements_full?(%__MODULE__{placements: placements}),
    do: !Enum.member?(placements, nil)

  def get_next_turn(%__MODULE__{next_turn: next_turn}) when is_nil(next_turn),
    do: :any

  def get_next_turn(%__MODULE__{next_turn: next_turn}) when not is_nil(next_turn),
    do: next_turn

  def game_won?(%__MODULE__{finished?: finished}), do: finished

  def get_winner(%__MODULE__{winner: winner}), do: winner

  # Internal helpers
  defp assign_next_turn(:x), do: :o
  defp assign_next_turn(:o), do: :x
  defp assign_next_turn(_), do: nil

  defp add_next_turn(move), do: assign_next_turn(move.symbol)
end
