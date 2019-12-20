defmodule TicTacToe.Game.Client do
  @moduledoc """
  Game CLI client.
  """
  require Logger
  alias TicTacToe.Game.Server
  alias TicTacToe.Game.Supervisor

  def start_link(), do: GenServer.start_link(Server, [])

  @doc """
  Starts a new game server under the DynamicSupervisor to oversee.
  Will only restart processes that crashed abnormally.
  """
  def new_game_server(),
    do:
      DynamicSupervisor.start_child(Supervisor, %{
        id: Server,
        start: {__MODULE__, :start_link, []},
        restart: :transient
      })

  @doc """
  Quit a game

  ## Examples
      iex> alias TicTacToe.Game.Client
      TicTacToe.Game.Client
      iex> alias TicTacToe.Game.Supervisor
      TicTacToe.Game.Supervisor
      iex> {:ok, server} = Client.new_game_server()
      {:ok, #PID<0.140.0>}
      iex> Client.quit(server)
      12:07:14.054 [warn]  Game server exited. Reason: :shutdown
      :ok
  """
  def quit(pid), do: Supervisor.exit_game(pid)

  @doc """
  Crash a game

  ## Examples
      iex> alias TicTacToe.Game.Client
      TicTacToe.Game.Client
      iex> alias TicTacToe.Game.Supervisor
      TicTacToe.Game.Supervisor
      iex> {:ok, server} = Client.new_game_server()
      {:ok, #PID<0.140.0>}
      iex> Client.crash(server)
      true
  """
  def crash(pid), do: Process.exit(pid, :kill)
end
