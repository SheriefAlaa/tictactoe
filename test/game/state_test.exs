defmodule TicTacToeTest.Game.StateTest do
  use ExUnit.Case

  alias TicTacToe.Game.{Board, State}
  alias TicTacToe.Game.State.Move

  test "new/0 will return a new game state struct" do
    %State{placements: placements} = State.new()
    assert length(placements) == 9
  end

  test "add_move/2 adds a move the game state" do
    board = Board.new("sherief")

    new_state =
      %Move{place: 0, symbol: :x}
      |> Move.validate()
      |> State.add_move(board.state)

    assert {:ok,
            %TicTacToe.Game.State{
              finished?: false,
              next_turn: :o,
              placements: [:x, nil, nil, nil, nil, nil, nil, nil, nil],
              winner: nil
            }} = new_state
  end

  test "add_won/1 checks if the game is won and adds a winner" do
    board = Board.new("sherief")

    {:ok, new_state} =
      %Move{place: 0, symbol: :x}
      |> Move.validate()
      |> State.add_move(board.state)
      |> State.add_won()

    {:ok, new_state} =
      %Move{place: 1, symbol: :o}
      |> Move.validate()
      |> State.add_move(new_state)
      |> State.add_won()

    {:ok, new_state} =
      %Move{place: 3, symbol: :x}
      |> Move.validate()
      |> State.add_move(new_state)
      |> State.add_won()

    {:ok, new_state} =
      %Move{place: 8, symbol: :o}
      |> Move.validate()
      |> State.add_move(new_state)
      |> State.add_won()

    {:ok, new_state} =
      %Move{place: 6, symbol: :x}
      |> Move.validate()
      |> State.add_move(new_state)
      |> State.add_won()

    assert %TicTacToe.Game.State{
             finished?: true,
             next_turn: :o,
             placements: [:x, :o, nil, :x, nil, nil, :x, nil, :o],
             winner: :x
           } = new_state
  end

  test "add_move/2 will only work for each player's turn" do
    board = Board.new("sherief")

    {:ok, new_state} =
      %Move{place: 0, symbol: :x}
      |> Move.validate()
      |> State.add_move(board.state)

    assert {:error, :not_your_turn} =
             %Move{place: 1, symbol: :x}
             |> Move.validate()
             |> State.add_move(new_state)
  end
end
