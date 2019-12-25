defmodule TicTacToe.Game.Client do
  @moduledoc """
  Game CLI client.
  """
  require Logger
  alias TicTacToe.Game.{Board, Server, Supervisor, State, State.Move}

  @doc """
  Starts a new game server under the DynamicSupervisor to oversee.
  Will only restart processes that crashed abnormally.

  Will enforce using strings over atoms as the latter is garbage collected.
  """
  def new_game_server(name) when is_binary(name) do
    DynamicSupervisor.start_child(
      Supervisor,
      {Server,
       name: {:via, Registry, {TicTacToe.ServerRegistry, name}},
       start: {Server, :start_link, [name]}}
    )
  end

  def new_game_server(_) do
    Logger.error("You can only use strings to start a new server.")
    {:error, :invalid_param}
  end

  @doc """
  Executes a play using a server name.
  """
  def play(server_name, place, symbol) when is_binary(server_name) do
    case get_pid(server_name) do
      {:ok, server_pid} ->
        # Pass to play() that uses server_pid
        play(server_pid, place, symbol)

      error ->
        error
    end
  end

  @doc """
  Executes a play using a server pid, will validate the move on board,
  update the game GenServer state, and draw the board.
  """
  def play(server_pid, place, player_symbol) when is_pid(server_pid) do
    move = %Move{place: place, symbol: player_symbol}

    case Move.validate(move) do
      {:ok, validated_move} ->
        do_play(server_pid, validated_move)

      error ->
        error
    end
  end

  def play(_, _, _), do: {:error, :invalid_server_name_or_pid}

  defp do_play(server_pid, %Move{} = move) do
    {:ok, board} = get_state(server_pid)

    if State.game_won?(board.state) do
      IO.puts("\n")
      IO.inspect("Game is already won by #{inspect(State.get_winner(board.state))}!")
      {:ok, board} |> Board.render()
      {:ok, :game_already_won}
    else
      update_state(server_pid, move, board)
    end
  end

  defp update_state(server_pid, move, board) do
    case State.add_move({:ok, move}, board.state) do
      {:ok, new_state} ->
        case State.add_won({:ok, new_state}) do
          {:ok, final_state} ->
            board = %{board | state: final_state}
            # Update State in server
            updated_state = GenServer.call(server_pid, {:alter_state, board})
            Board.render({:ok, updated_state})
            {:ok, updated_state}
        end

      error ->
        error
    end
  end

  @doc """
  Get server state using server pid
  """
  def get_state(server_pid) when is_pid(server_pid),
    do: {:ok, GenServer.call(server_pid, :get_state)}

  @doc """
  Get server state using server name in Elixir.Registry
  """
  def get_state(server_name) when is_binary(server_name) do
    case get_pid(server_name) do
      {:ok, server_pid} ->
        {:ok, GenServer.call(server_pid, :get_state)}

      {:error, reason} ->
        {:error, reason}
    end
  end

  def get_state(_), do: {:error, :invalid_param}

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
    do: {:ok, result |> hd() |> elem(0)}

  def get_pid(result) when is_list(result) and length(result) == 0, do: {:error, :not_found}

  def get_pid(_) do
    Logger.error("Game name are strictly strings. Please enter a string.")
    {:error, :invalid_param}
  end
end
