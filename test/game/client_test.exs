defmodule TicTacToeTest.Game.ClientTest do
  use ExUnit.Case
  @moduletag capture_log: true

  import ExUnit.CaptureIO

  alias TicTacToe.Game.{Client, Supervisor}

  setup do
    ExUnit.Callbacks.start_supervised!(
      {Registry, keys: :unique, name: TicTacToe.ServerRegistry},
      []
    )

    ExUnit.Callbacks.start_supervised!(Supervisor, [])
    :ok
  end

  test "new_game_server/1 creates a new game server under a dynamic supervisor" do
    {:ok, pid} = Client.new_game_server("sherief1")

    assert Process.alive?(pid)
    assert [{_, ^pid, _, _}] = Supervisor.list_children()
  end

  test "new_game_server/1 requires a string" do
    assert {:error, :invalid_param} = Client.new_game_server([])
  end

  test "crash/1 crashes a process under a dynamic supervisor" do
    {:ok, pid} = Client.new_game_server("sherief2")

    assert Process.alive?(pid)
    assert [{_, ^pid, _, _}] = Supervisor.list_children()
    Client.crash(pid)
    refute Process.alive?(pid)
    assert length(Supervisor.list_children()) == 1

    [{_, new_pid, _, _}] = Supervisor.list_children()

    assert new_pid != pid
  end

  test "get_pid/1 returns a game server pid when given a game name" do
    game_name = "sherief007"
    {:ok, pid} = Client.new_game_server(game_name)

    assert {:ok, pid} == Client.get_pid(game_name)
  end

  test "get_pid/1 requires a string as input" do
    atom_name = :sherief2
    string_name = "sherief2"
    {:ok, _pid} = Client.new_game_server(string_name)

    assert {:error, :invalid_param} = Client.get_pid(atom_name)
  end

  test "get_state/1 returns server state using server name" do
    string_name = "sherief2"
    {:ok, _pid} = Client.new_game_server(string_name)
    assert {:ok, state} = Client.get_state(string_name)
    assert %TicTacToe.Game.Board{} = state
  end

  test "get_state/1 returns server state using server pid" do
    {:ok, pid} = Client.new_game_server("servername")
    assert {:ok, state} = Client.get_state(pid)
    assert %TicTacToe.Game.Board{} = state
  end

  test "get_state/1 returns error if param is not name or pid" do
    assert {:error, _} = Client.get_state(123)
  end

  test "play/3 updates game board state and renders it when given correct server_pid and move" do
    {:ok, pid} = Client.new_game_server("servername")

    fun = fn ->
      {:ok, board} = Client.play(pid, 0, :x)
      assert board.state.placements |> hd() == :x
    end

    assert capture_io(fun) ==
             "\n X | - | - \n-----------\n - | - | - \n-----------\n - | - | - \n"
  end

  test "play/3 updates game board state and renders it when given correct server_name and move" do
    string_name = "servername"
    {:ok, _pid} = Client.new_game_server(string_name)

    fun = fn ->
      {:ok, board} = Client.play(string_name, 0, :o)
      assert board.name == string_name
      assert board.state.placements |> hd() == :o
    end

    assert capture_io(fun) ==
             "\n O | - | - \n-----------\n - | - | - \n-----------\n - | - | - \n"
  end

  test "play/3 refuses a play that was already filled" do
    string_name = "servername"
    {:ok, _pid} = Client.new_game_server(string_name)

    fun = fn ->
      {:ok, board} = Client.play(string_name, 0, :o)
      assert board.name == string_name
      assert board.state.placements |> hd() == :o
      {:error, :already_played} = Client.play(string_name, 0, :x)
    end

    assert capture_io(fun) ==
             "\n O | - | - \n-----------\n - | - | - \n-----------\n - | - | - \n"
  end

  test "play/3 updates the game state as won/finished" do
    string_name = "servername"
    {:ok, _pid} = Client.new_game_server(string_name)

    fun = fn ->
      {:ok, board} = Client.play(string_name, 0, :o)
      assert is_nil(board.state.winner)
      {:ok, board} = Client.play(string_name, 8, :x)
      assert is_nil(board.state.winner)
      {:ok, board} = Client.play(string_name, 1, :o)
      assert is_nil(board.state.winner)
      {:ok, board} = Client.play(string_name, 7, :x)
      assert is_nil(board.state.winner)
      {:ok, board} = Client.play(string_name, 2, :o)
      assert board.state.winner == :o

      assert {:ok, :game_already_won} = Client.play(string_name, 4, :x)

      assert board.name == string_name
    end

    assert capture_io(fun) ==
             "\n O | - | - \n-----------\n - | - | - \n-----------\n - | - | - \n\n O | - | - \n-----------\n - | - | - \n-----------\n - | - | X \n\n O | O | - \n-----------\n - | - | - \n-----------\n - | - | X \n\n O | O | - \n-----------\n - | - | - \n-----------\n - | X | X \n\n O | O | O \n-----------\n - | - | - \n-----------\n - | X | X \n\n\n\"Game is already won by :o!\"\n\n O | O | O \n-----------\n - | - | - \n-----------\n - | X | X \n"
  end
end
