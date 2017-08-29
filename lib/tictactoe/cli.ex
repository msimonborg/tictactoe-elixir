defmodule TicTacToe.CLI do
  alias TicTacToe.CLI
  alias TicTacToe.Game
  alias TicTacToe.Game.Board
  
  use GenServer

  @doc """
  Starts the game with the given options.
  
  `:name` is always required.
  """
  def start_link(opts) do
    GenServer.start_link(TicTacToe.CLI.Server, :ok, opts)
  end

  def main(_args) do
    Application.start(:tictactoe)
    :observer.start
    start()
  end

  def start do
    input = IO.gets("What's your first move? (X|O) ") |> String.trim
    Game.move(game(), 1, input)
    display()
  end

  def game, do: GenServer.call(CLI, :game)

  def board_positions, do: game() |> Game.board() |> Board.positions()

  defp display do
    IO.puts " #{Enum.at(board_positions(), 0)} | #{Enum.at(board_positions(), 1)} | #{Enum.at(board_positions(), 2)} "
    IO.puts "-----------"
    IO.puts " #{Enum.at(board_positions(), 3)} | #{Enum.at(board_positions(), 4)} | #{Enum.at(board_positions(), 5)} "
    IO.puts "-----------"
    IO.puts " #{Enum.at(board_positions(), 6)} | #{Enum.at(board_positions(), 7)} | #{Enum.at(board_positions(), 8)} "
  end
end