defmodule TicTacToe.CLI do
  @moduledoc """
  Main CLI interface.
  """

  use GenServer

  alias TicTacToe.Game
  alias TicTacToe.Game.Board
  alias TicTacToe.Game.Rules

  @doc """
  Starts the game with the given options.
  """
  def start_link(opts) do
    GenServer.start_link(TicTacToe.CLI.Server, :ok, opts)
  end

  def main(_args) do
    Application.start(:tictactoe)
    first_player = "Who's going first? [X|O] -> " |> get_input() |> validate_player()    
    play(first_player)        
  end

  def play(:over) do
    output = result()
    display()
    IO.puts(output)
    "Play again? [y|n] -> " 
    |> get_input()
    |> String.downcase()
    |> play_again?()
  end

  def play(player) do
    display()
    position = "Select a square, #{player} -> " |> get_input() |> String.to_integer()
    Game.move(game(), position, player)
    case Rules.over?(board_positions()) do
      true  -> play(:over)
      false -> game() |> Game.current_player() |> play()
    end
  end

  def play_again?(input) do
    case input do
      "y" ->
        GenServer.call(__MODULE__, :new_game)
        main([])
      "n" -> 
        nil
      _ -> 
        "Must be y or n -> "
        |> get_input()
        |> String.downcase()
        |> play_again?()
    end
  end

  def result do
    case Rules.won?(board_positions()) do
      true ->
        case Game.current_player(game()) do
          "X" -> "\nO wins!"
          "O" -> "\nX wins!"
        end
      false ->
        "\nCat's game!"
    end
  end

  def validate_player(input) do
    case String.upcase(input) do
      "X" -> "X"
      "O" -> "O"
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

  defp display(index) when is_integer(index), do: Enum.at(board_positions(), index)
  defp display do
    IO.puts "\n #{display(0)} | #{display(1)} | #{display(2)} "
    IO.puts "-----------"
    IO.puts " #{display(3)} | #{display(4)} | #{display(5)} "
    IO.puts "-----------"
    IO.puts " #{display(6)} | #{display(7)} | #{display(8)} "
  end
end