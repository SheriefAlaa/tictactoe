defmodule TicTacToe.Game.Cache do
  @state_cache_bucket :game_server_state_bucket

  def create_games_table() do
    :ets.new(@state_cache_bucket, [:named_table, :set, :public])
  end

  def add(name, state) when is_binary(name) and is_map(state) do
    :ets.insert(@state_cache_bucket, {name, state})
  end

  def lookup(name) when is_binary(name) do
    :ets.lookup(@state_cache_bucket, name) |> lookup_result()
  end

  def delete(name) do
    :ets.delete(@state_cache_bucket, name)
  end

  defp lookup_result([]), do: {:error, :not_found}
  defp lookup_result(list) when is_list(list) and length(list) == 1, do: {:ok, hd(list)}
  defp lookup_result(list) when is_list(list) and length(list) > 1, do: {:error, :more_than_one}
end
