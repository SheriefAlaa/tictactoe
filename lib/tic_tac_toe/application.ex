defmodule TicTacToe.Application do
  use Application

  def start(_type, _args) do
    children =
      if Mix.env() == :test do
        []
      else
        [TicTacToe.Game.Supervisor]
      end

    opts = [strategy: :one_for_one, name: TicTacToe.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
