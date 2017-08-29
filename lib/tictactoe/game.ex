defmodule TicTacToe.Game do
  @moduledoc """
  Client API for the `TicTacToe.Game.Server`
  """

  use GenServer, restart: :temporary

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

  def start_board do
    TicTacToe.Game.Board.start_link([])
  end

  @doc """
  Makes a move and returns the board state.
  """
  def move(game, position, value) do
    GenServer.call(game, {:move, position, value})
  end
end