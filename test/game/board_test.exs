defmodule TicTacToeTest.Game.BoardTest do
  use ExUnit.Case

  alias TicTacToe.Game.Board

  describe "Board struct" do
    test "new/0 will return a new game board struct" do
      %Board{places: places} = Board.new()
      assert length(places) == 9
    end
  end
end
