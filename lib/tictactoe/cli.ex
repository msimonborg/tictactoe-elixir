defmodule TicTacToe.CLI do
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
    :observer.start
    Application.start(:tictactoe)
    first_player = "Who's going first? (X|O) -> " |> get_input() |> validate_player()    
    play(first_player)        
  end

  def play(player) do
    display()
    position = "Select a square, #{player} -> " |> get_input() |> String.to_integer()
    Game.move(game(), position, player)
    game() |> Game.current_player() |> play()
  end

  def validate_player(input) do
    case input do
      "X" -> input
      "O" -> input
      _   -> "Must be X or O -> " |> get_input() |> validate_player()
    end
  end

  def get_input(msg) do
    IO.puts ""
    msg
    |> IO.gets()
    |> String.trim()
  end

  def game, do: GenServer.call(__MODULE__, :game)

  def board_positions, do: game() |> Game.board() |> Board.positions()

  defp display do
    IO.puts " #{Enum.at(board_positions(), 0)} | #{Enum.at(board_positions(), 1)} | #{Enum.at(board_positions(), 2)} "
    IO.puts "-----------"
    IO.puts " #{Enum.at(board_positions(), 3)} | #{Enum.at(board_positions(), 4)} | #{Enum.at(board_positions(), 5)} "
    IO.puts "-----------"
    IO.puts " #{Enum.at(board_positions(), 6)} | #{Enum.at(board_positions(), 7)} | #{Enum.at(board_positions(), 8)} "
  end
end