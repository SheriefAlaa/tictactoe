## How to manually install asdf-vm:

First of all you will need to have asdf-vm, a CLI tool that allows
having multiple versions of your programming language.

- Get the latest code from github:
    ```
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.7.6
    ```
- Add it to your shell using: 
    ```
    echo -e '\n. $HOME/.asdf/asdf.sh' >> ~/.bashrc 
    echo -e '\n. $HOME/.asdf/completions/asdf.bash' >> ~/.bashrc
    ```
- Add Elixir asdf plugin:
    ```
    asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git
    ```
- Add Erlang asdf plugin:
    ```
    asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git
    ```
- While inside the project's root, execute the following to install Elixir & Erlang:
    ```
    asdf install elixir 1.9.1-otp-22
    asdf install erlang 22.0.7
    ```
- Add Elixir and Erlang to your project's local directory:
    ```
    asdf local elixir 1.9.1-otp-22
    asdf local erlang 22.0.7
    ```

## How to install TicTacToe:
    mix deps.get

## Running TicTacToe:
    iex -S mix