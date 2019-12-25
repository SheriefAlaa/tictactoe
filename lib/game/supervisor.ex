defmodule TicTacToe.Game.Supervisor do
  use DynamicSupervisor

  alias TicTacToe.Game.Cache

  require Logger

  @doc """
  Starts the game's DynamicSupervisor that will restart
  sub processes of games on failure.
  """
  def start_link(_) do
    case DynamicSupervisor.start_link(__MODULE__, nil, name: __MODULE__) do
      {:ok, pid} ->
        Logger.info("Started the game's DynamicSupervisor #{inspect(pid)} ")
        Logger.info("You can now do: ")
        Logger.info("alias TicTacToe.Game.Client")
        Logger.info("{:ok, server} = Client.new_game_server(\"sherief\")")
        Cache.create_games_table()

        {:ok, pid}

      {:error, reason} ->
        Logger.error("Could not start the game's supervisor, reason: #{inspect(reason)}")
    end
  end

  @doc """
  DynamicSupervisor specific method for initializing state
  with a strategy that will restart processes individually.
  """
  @impl true
  def init(_arg), do: DynamicSupervisor.init(strategy: :one_for_one)

  @doc """
  List all DynamicSupervisor's current children.
  """
  def list_children(), do: DynamicSupervisor.which_children(__MODULE__)

  @doc """
  Terminate a child of the DynamicSupervisor
  """
  def exit_game(pid), do: DynamicSupervisor.terminate_child(__MODULE__, pid)
end
