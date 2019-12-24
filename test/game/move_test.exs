defmodule TicTacToeTest.Game.State.MoveTest do
  use ExUnit.Case
  @moduletag capture_log: true

  alias TicTacToe.Game.State.Move

  test "new/1 requires a certain range for placement" do
    assert {:error, :incorrect_placement} == Move.new(%Move{symbol: :x, place: 0})
    assert {:ok, %Move{place: 3, symbol: :x}} = Move.new(%Move{symbol: :x, place: 3})
  end

  test "new/1 requires a move struct" do
    assert {:error, :bad_struct} == Move.new(%{symbol: :x, place: 2})
    assert {:ok, %Move{place: 3, symbol: :x}} == Move.new(%Move{symbol: :x, place: 3})
  end

  test "new/1 requires a symbol to be an atom" do
    assert {:error, :symbol_not_atom} == Move.new(%Move{symbol: "x", place: 1})
    assert {:ok, %Move{place: _, symbol: _}} = Move.new(%Move{symbol: :x, place: 1})
  end

  test "new/1 requires :x or :o as symbols" do
    assert {:error, :incorrect_symbol} == Move.new(%Move{symbol: :z, place: 1})
    assert {:ok, %Move{place: _, symbol: _}} = Move.new(%Move{symbol: :x, place: 1})
    assert {:ok, %Move{place: _, symbol: _}} = Move.new(%Move{symbol: :o, place: 9})
  end

  test "new/1 requires none null values" do
    assert {:error, :missing_symbol} == Move.new(%Move{place: 1})
    assert {:error, :missing_place} == Move.new(%Move{symbol: :x})

  end
end
