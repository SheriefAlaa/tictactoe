defmodule TicTacToeTest.Game.ClientTest do
  use ExUnit.Case
  @moduletag capture_log: true

  alias TicTacToe.Game.Client
  alias TicTacToe.Game.Supervisor

  setup do
    ExUnit.Callbacks.start_supervised!(Supervisor, [])
    :ok
  end

  test "new_game_server/0 creates a new game server under a dynamic supervisor" do
    {:ok, pid} = Client.new_game_server()

    assert Process.alive?(pid)
    assert [{_, ^pid, _, _}] = Supervisor.list_children()
  end

  test "crash/1 crashes a process under a dynamic supervisor" do
    {:ok, pid} = Client.new_game_server()

    assert Process.alive?(pid)
    assert [{_, ^pid, _, _}] = Supervisor.list_children()
    Client.crash(pid)
    refute Process.alive?(pid)
    assert length(Supervisor.list_children()) == 1

    [{_, new_pid, _, _}] = Supervisor.list_children()

    assert new_pid != pid
  end
end
