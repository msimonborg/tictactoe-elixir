defmodule TicTacToe.Game do
  @moduledoc """
  Client API for the `TicTacToe.Game.Server`
  """

  use GenServer, restart: :temporary

  alias TicTacToe.Game
  alias TicTacToe.Game.Board
  alias TicTacToe.Game.Rules

  @doc """
  Starts the game with the given options.
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

      iex> {:ok, pid} = TicTacToe.Game.start_link([])
      iex> TicTacToe.Game.move(pid, 2, "X")
      %TicTacToe.Game.Board{
        positions: [" ", "X", " ", " ", " ", " ", " ", " ", " "],
        history: [2]
      }
      iex> TicTacToe.Game.move(pid, 3, "X")
      {:error, "play out of turn"}
      iex> TicTacToe.Game.move(pid, 5, "O")
      %TicTacToe.Game.Board{
        positions: [" ", "X", " ", " ", "O", " ", " ", " ", " "],
        history: [2, 5]
      }

      iex> {:ok, pid} = TicTacToe.Game.start_link([])
      iex> TicTacToe.Game.move(pid, 2, "X")
      %TicTacToe.Game.Board{
        positions: [" ", "X", " ", " ", " ", " ", " ", " ", " "],
        history: [2]
      }
      iex> TicTacToe.Game.move(pid, 5)
      %TicTacToe.Game.Board{
        positions: [" ", "X", " ", " ", "O", " ", " ", " ", " "],
        history: [2, 5]
      }
      iex> TicTacToe.Game.move(pid, 6)
      %TicTacToe.Game.Board{
        positions: [" ", "X", " ", " ", "O", "X", " ", " ", " "],
        history: [2, 5, 6]
      }

      iex> {:ok, pid} = TicTacToe.Game.start_link([])
      iex> TicTacToe.Game.move(pid, 3)
      {:error, "select a player on the first move"}
  """
  def move(game, position, value) do
    case game |> board() |> Board.history() |> length() do
      0 ->
        GenServer.call(game, {:move, position, value})
      _ ->
        case current_player(game) do
          ^value -> GenServer.call(game, {:move, position, value})
          _      -> {:error, "play out of turn"}
        end
    end
  end

  def move(game, position) do
    case current_player(game) do
      {:error, "first turn not taken"} ->
        {:error, "select a player on the first move"}
      player ->
        move(game, position, player)
    end
  end

  @doc """
  Returns the current player.

  Returns `:error` if there have been no moves made.

  ## Examples

      iex> {:ok, game_pid} = TicTacToe.Game.start_link([])
      iex> TicTacToe.Game.current_player(game_pid)
      {:error, "first turn not taken"}
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
      {:error, _msg}        -> {:error, "first turn not taken"}
    end
  end

  def simulate(game) do
    positions = Enum.to_list(1..9)
    position  = Enum.random(positions)
    move(game, position, "X")
    simulate(game, positions -- [position])
  end

  def simulate(game, positions) do
    position = Enum.random(positions)
    move(game, position)
    case game |> Game.board() |> Board.positions() |> Rules.over?() do
      {:ok, false} ->
        simulate(game, positions -- [position])
      {:ok, _}  ->
        final_game_state = game |> Game.board() |> Board.current_state()
        Supervisor.terminate_child(TicTacToe.Game.Supervisor, game)
        final_game_state
    end
  end
end
