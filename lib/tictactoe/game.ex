defmodule TicTacToe.Game do
  @moduledoc """
  Client API for the `TicTacToe.Game.Server`
  """

  use GenServer, restart: :temporary

  alias TicTacToe.Game.Board

  @doc """
  Starts the game with the given options.
  
  `:name` is always required.
  """
  def start_link(opts), do: GenServer.start_link(TicTacToe.Game.Server, :ok, opts)

  @doc """
  Returns the game board PID.
  """
  def board(game), do: GenServer.call(game, :board)

  @doc """
  Starts a linked game board.
  """
  def start_board, do: Board.start_link([])

  @doc """
  Makes a move and returns the board state. Does not allow the same player to move twice
  in a row.

  ## Examples

      iex> {:ok, game_pid} = TicTacToe.Game.start_link([])
      iex> TicTacToe.Game.move(game_pid, 2, "X")
      {[" ", "X", " ", " ", " ", " ", " ", " ", " "], [2]}
      iex> TicTacToe.Game.move(game_pid, 3, "X")
      :error
      iex> TicTacToe.Game.move(game_pid, 3, "O")
      {[" ", "X", "O", " ", " ", " ", " ", " ", " "], [2, 3]}
  
  """
  def move(game, position, value) do
    case game |> board() |> Board.history() |> length() do
      0 ->
        GenServer.call(game, {:move, position, value})
      _ ->
        case current_player(game) do
          ^value -> GenServer.call(game, {:move, position, value})
          _      -> :error
        end
    end
  end

  @doc """
  Returns the current player.

  Returns `:error` if there have been no moves made.

  ## Examples

      iex> {:ok, game_pid} = TicTacToe.Game.start_link([])
      iex> TicTacToe.Game.current_player(game_pid)
      :error
      iex> TicTacToe.Game.move(game_pid, 3, "X")
      iex> TicTacToe.Game.current_player(game_pid)
      "O"
      iex> TicTacToe.Game.move(game_pid, 4, "X")
      iex> TicTacToe.Game.current_player(game_pid)
      "O"
      iex> TicTacToe.Game.move(game_pid, 4, "O")
      iex> TicTacToe.Game.current_player(game_pid)
      "X"

  """
  def current_player(game) do
    case game |> board() |> Board.last_move() do
      {:ok, _position, "X"} -> "O"
      {:ok, _position, "O"} -> "X"
      :error                -> :error
    end
  end
end
