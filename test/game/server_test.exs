defmodule TicTacToeTest.Game.ServerTest do
  use ExUnit.Case
  @moduletag capture_log: true

  alias TicTacToe.Game.{Supervisor, Server}

  setup do
    ExUnit.Callbacks.start_supervised!(
      {Registry, keys: :unique, name: TicTacToe.ServerRegistry},
      []
    )

    ExUnit.Callbacks.start_supervised!(Supervisor, [])
    :ok
  end

  test "start_link/1 creates a process with game board as state" do
    assert {:ok, _pid} = Server.start_link(get_opts("sherief"))
  end

  defp get_opts(name) do
    [
      id: Server,
      name: {:via, Registry, {TicTacToe.ServerRegistry, name}},
      start: {Server, :start_link, [name]}
    ]
  end
end
