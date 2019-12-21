defmodule TicTacToeTest.Game.BoardTest do
  use ExUnit.Case

  alias TicTacToe.Game.{Board, State}

  describe "Board struct" do
    test "new/0 will return a new game board struct" do
      name = "sherief"
      assert %Board{name: ^name, state: state} = Board.new(name)
      assert length(state.places) == 9
    end
  end
end
