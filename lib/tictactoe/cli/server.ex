defmodule TicTacToe.CLI.Server do
  @moduledoc """
  CLI server.
  """

  # alias TicTacToe.Game.Board
  alias TicTacToe.Game

  @doc """
  Starts the CLI server and initializes the game as the server state.
  """
  def init(:ok), do: Game.Supervisor.start_game

  def handle_call(:game, _from, game), do: {:reply, game, game}
end