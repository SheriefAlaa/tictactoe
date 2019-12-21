defmodule TicTacToeTest.Game.ClientTest do
  use ExUnit.Case
  @moduletag capture_log: true

  alias TicTacToe.Game.Client
  alias TicTacToe.Game.Supervisor

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

    assert pid == Client.get_pid(game_name)
  end

  test "get_pid/1 requires a string as input" do
    atom_name = :sherief2
    string_name = "sherief2"
    {:ok, _pid} = Client.new_game_server(string_name)

    assert {:error, :invalid_param} = Client.get_pid(atom_name)
  end
end
