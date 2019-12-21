defmodule TicTacToeTest.Game.StateTest do
  use ExUnit.Case

  alias TicTacToe.Game.State

  describe "State struct" do
    test "new/0 will return a new game state struct" do
      %State{places: places} = State.new()
      assert length(places) == 9
    end
  end
end
