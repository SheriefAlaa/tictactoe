defmodule TicTacToeTest.Game.State.MoveTest do
  use ExUnit.Case
  @moduletag capture_log: true

  alias TicTacToe.Game.State.Move

  test "validate/1 requires a certain range for placement" do
    assert {:error, :incorrect_placement} == Move.validate(%Move{symbol: :x, place: 10})
    assert {:ok, %Move{place: 3, symbol: :x}} = Move.validate(%Move{symbol: :x, place: 3})
  end

  test "validate/1 requires a move struct" do
    assert {:error, :bad_struct} == Move.validate(%{symbol: :x, place: 2})
    assert {:ok, %Move{place: 3, symbol: :x}} == Move.validate(%Move{symbol: :x, place: 3})
  end

  test "validate/1 requires a symbol to be an atom" do
    assert {:error, :symbol_not_atom} == Move.validate(%Move{symbol: "x", place: 1})
    assert {:ok, %Move{place: _, symbol: _}} = Move.validate(%Move{symbol: :x, place: 1})
  end

  test "validate/1 requires :x or :o as symbols" do
    assert {:error, :incorrect_symbol} == Move.validate(%Move{symbol: :z, place: 1})
    assert {:ok, %Move{place: _, symbol: _}} = Move.validate(%Move{symbol: :x, place: 1})
    assert {:ok, %Move{place: _, symbol: _}} = Move.validate(%Move{symbol: :o, place: 8})
  end

  test "validate/1 requires none null values" do
    assert {:error, :missing_symbol} == Move.validate(%Move{place: 1})
    assert {:error, :missing_place} == Move.validate(%Move{symbol: :x})
  end
end
