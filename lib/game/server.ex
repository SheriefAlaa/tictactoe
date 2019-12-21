defmodule TicTacToe.Game.Server do
  @moduledoc """
  Game server callbacks module.
  """
  use GenServer, restart: :transient

  require Logger

  alias TicTacToe.Game.{Board, Cache}

  def start_link(opts) do
    board =
      opts
      |> get_name()
      |> Board.new()

    case Cache.lookup(board.name) do
      {:ok, {_, old_state}} ->
        Logger.info("Recovered a process from a crash!")
        GenServer.start_link(__MODULE__, old_state, opts)

      {:error, :not_found} ->
        Cache.add(board.name, board)
        Logger.info("Created a new game board.")
        GenServer.start_link(__MODULE__, board, opts)

      {:error, :more_than_one} ->
        Logger.error(
          "Seems ETS has more than one state for this process name: #{inspect(board.name)}"
        )
        GenServer.start_link(__MODULE__, board, opts)
    end
  end

  @doc """
  GenServer specific callback necessary for state init.
  Used mainly at start_link/2.
  """
  @impl true
  def init(state) do
    Process.flag(:trap_exit, true)
    {:ok, state}
  end

  @impl true
  def handle_info({:EXIT, pid, :normal}, _state) do
    Logger.info("Game process #{inspect(pid)} exited cleanly.")
    {:stop, :shutdown, nil}
  end

  @impl true
  def terminate(reason, state) do
    Logger.warn("Game server exited. Reason: #{inspect(reason)}")
    Cache.delete(state.name)
    {reason, state}
  end

  defp get_name(opts) do
    {:start, {TicTacToe.Game.Server, :start_link, [name]}} = List.keyfind(opts, :start, 0)
    name
  end
end
