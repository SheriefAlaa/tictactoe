defmodule TicTacToe.Game.Client do
  @moduledoc """
  Game CLI client.
  """
  require Logger
  alias TicTacToe.Game.Board
  alias TicTacToe.Game.Server
  alias TicTacToe.Game.Supervisor

  def start_link(), do: GenServer.start_link(Server, Board.new())

  @doc """
  Starts a new game server under the DynamicSupervisor to oversee.
  Will only restart processes that crashed abnormally.

  Will enforce using strings over atoms as the latter is garbage collected.
  """
  def new_game_server(name) when is_binary(name) do
    DynamicSupervisor.start_child(
      Supervisor,
      {Server, name: {:via, Registry, {TicTacToe.ServerRegistry, name}}}
    )
  end

  def new_game_server(_) do
    Logger.error("You can only use strings to start a new server.")
    {:error, :invalid_param}
  end

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

  @doc """
  Get a game pid from Elixir.Registry using a string
  """
  def get_pid(game_name) when is_binary(game_name) do
    result = Registry.lookup(TicTacToe.ServerRegistry, game_name)
    get_pid(result)
  end

  def get_pid(result) when is_list(result) and length(result) == 1,
    do: result |> hd() |> elem(0)

  def get_pid(result) when is_list(result) and length(result) == 0, do: nil

  def get_pid(_) do
    Logger.error("Game name are strictly strings. Please enter a string.")
    {:error, :invalid_param}
  end
end
