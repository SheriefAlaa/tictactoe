## How to start playing:

The game uses a Logger to make your life easier navigating the game, but we decided to write a step by step guide anyway.

  ```
  iex -S mix
  alias TicTacToe.Game.Client
  {:ok, server_pid} = Client.new_game_server("game_1")
  # First move on board using Client.play(server_pid_or_name, place, players_symbol)
  Client.play(server, 0, :x)
  ```

## How to display the game board:

  ```
  alias TicTacToe.Game.Board
  Client.get_state("game_1") |> Board.render()
  # or
  Client.get_state(server_pid) |> Board.render()
  ```

## Other supported methods:

  ```
  {:ok, pid} = Client.get_pid("game_1")  #just in case you forgot to save server pid.

  Client.crash(server_pid) #will crash the game server.
  ```

## Running tests:
  ```
  mix test
  ```