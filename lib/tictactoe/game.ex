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
  def start_link(opts) do
    GenServer.start_link(TicTacToe.Game.Server, :ok, opts)
  end

  @doc """
  Gets the game board.
  """
  def board(game) do
    GenServer.call(game, :board)
  end

  @doc """
  Starts a linked game board.
  """
  def start_board do
    Board.start_link([])
  end

  @doc """
  Makes a move and returns the board state.
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
  """
  def current_player(game) do
    case game |> board() |> Board.last_move() do
      {:ok, _position, "X"} -> "O"
      {:ok, _position, "O"} -> "X"
      :error                -> :error      
    end
  end
end