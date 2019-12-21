defmodule TicTacToeTest.Game.SupervisorTest do
  use ExUnit.Case, async: false
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

  test "exit_game/1 will exit a game server process cleanly" do
    {:ok, server} = Client.new_game_server("sherief")
    assert length(Supervisor.list_children()) == 1
    Supervisor.exit_game(server)
    assert length(Supervisor.list_children()) == 0
  end

  test "list_children/0 returns back a list of currently supervised game servers" do
    assert length(Supervisor.list_children()) == 0
    {:ok, server} = Client.new_game_server("sherief")
    assert length(Supervisor.list_children()) == 1
    assert [{_, ^server, _, _}] = Supervisor.list_children()
    assert server == Client.get_pid("sherief")
    Client.quit(server)
  end

  # Fault tolerance
  test "supervisor will restart child if it exited abormally/crashed" do
    {:ok, server1} = Client.new_game_server("sherief1")
    {:ok, server2} = Client.new_game_server("sherief2")
    {:ok, server3} = Client.new_game_server("sherief3")

    assert length(Supervisor.list_children()) == 3

    Client.crash(server2)
    Client.crash(server3)

    assert length(Supervisor.list_children()) == 3

    Client.quit(server1)
    Client.quit(server2)
    Client.quit(server3)
  end
end
