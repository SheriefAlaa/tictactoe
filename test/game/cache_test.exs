defmodule TicTacToeTest.Game.CacheTest do
  use ExUnit.Case
  @moduletag capture_log: true

  @state_cache_bucket :game_server_state_bucket

  alias TicTacToe.Game.{Cache, Board}

  test "create_games_table/0 creates a named ETS table to cache game state" do
    assert @state_cache_bucket = :ets.new(@state_cache_bucket, [:named_table, :set, :public])
  end

  test "add/2 inserts a game board into an ETS named table" do
    :ets.new(@state_cache_bucket, [:named_table, :set, :public])
    name = "sherief"
    board = Board.new(name)
    assert Cache.add(name, board)
    assert [{^name, ^board}] = :ets.lookup(@state_cache_bucket, name)
  end

  test "lookup/1 searchs for a row using a process name" do
    :ets.new(@state_cache_bucket, [:named_table, :set, :public])
    name = "sherief"
    board = Board.new(name)
    Cache.add(name, board)

    assert {:ok, {^name, ^board}} = Cache.lookup(name)
  end

  test "lookup/1 will return error if process name was not found" do
    :ets.new(@state_cache_bucket, [:named_table, :set, :public])
    assert {:error, not_found} = Cache.lookup("fake process")
  end

  test "lookup/1 will override data for same process name" do
    :ets.new(@state_cache_bucket, [:named_table, :set, :public])
    name = "sherief"
    board = Board.new(name)
    Cache.add(name, board)
    Cache.add(name, %{board | state: nil})

    assert {:ok, {_, %{state: nil}}} = Cache.lookup(name)
  end

  test "delete/1 deletes a row in the ETS table" do
    :ets.new(@state_cache_bucket, [:named_table, :set, :public])
    name = "sherief"
    board = Board.new(name)
    Cache.add(name, board)
    assert {:ok, {^name, ^board}} = Cache.lookup(name)
    Cache.delete(name)
    assert {:error, :not_found} = Cache.lookup(name)
  end
end
