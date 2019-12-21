defmodule TicTacToe.Game.Server do
  @moduledoc """
  Game server callbacks module.
  """
  use GenServer, restart: :transient

  require Logger

  alias TicTacToe.Game.Board

  def start_link(opts), do: GenServer.start_link(__MODULE__, Board.new(), opts)

  @doc """
  GenServer specific callback necessary for state init.
  Used mainly at start_link/2.
  """
  @impl true
  def init(state) do
    Process.flag(:trap_exit, true)
    {:ok, state}
  end

  @doc """
  New game sync callback.
  """
  @impl true
  def handle_call(:new_game, _from, _state) do
    state = Board.new()
    {:reply, state, state}
  end

  @impl true
  def handle_info({:EXIT, pid, :normal}, _state) do
    Logger.info("Game process #{inspect(pid)} exited cleanly.")
    {:stop, :shutdown, nil}
  end

  def handle_info(msg, _state) do
    Logger.info("Received abnormal message: #{inspect(msg)}")
    {:stop, nil, nil}
  end

  @impl true
  def terminate(reason, state) do
    Logger.warn("Game server exited. Reason: #{inspect(reason)}")
    {reason, state}
  end
end
