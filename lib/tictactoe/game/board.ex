defmodule TicTacToe.Game.Board do
  @moduledoc """
  Manages the game board state.
  """

  use Agent, restart: :temporary

  defstruct positions: List.duplicate(" ", 9), history: []

  @doc """
  Starts a new game board, a tuple with two lists. 
  
  The first list represents the value of each board square,
  initialized with nine elements all set to `" "`.

  The second list is the game history, or the order in which
  each move was made.

  ## Examples

      iex> {:ok, pid} = TicTacToe.Game.Board.start_link([])
      iex> Process.alive?(pid)
      true
  
  """
  def start_link(_opts) do
    Agent.start_link fn -> %TicTacToe.Game.Board{} end
  end

  @doc """
  Returns the current board state.

  ## Examples

      iex> {:ok, pid} = TicTacToe.Game.Board.start_link([])
      iex> TicTacToe.Game.Board.current_state(pid)
      %TicTacToe.Game.Board{
        positions: [" "," "," "," "," "," "," "," "," "], 
        history: []
      }
  
  """
  def current_state(pid), do: Agent.get(pid, &(&1))

  @doc """
  Returns the board history.

  ## Examples

      iex> {:ok, pid} = TicTacToe.Game.Board.start_link([])
      iex> TicTacToe.Game.Board.history(pid)
      []
  
  """
  def history(pid), do: pid |> current_state() |> Map.get(:history)

  @doc """
  Returns the board positions.

  ## Examples

      iex> {:ok, pid} = TicTacToe.Game.Board.start_link([])
      iex> TicTacToe.Game.Board.positions(pid)
      [" ", " ", " ", " ", " ", " ", " ", " ", " "]

      iex> {:ok, pid} = TicTacToe.Game.Board.start_link([])
      iex> pid |> TicTacToe.Game.Board.current_state() |> TicTacToe.Game.Board.positions()
      [" ", " ", " ", " ", " ", " ", " ", " ", " "]
  
  """
  def positions(%{} = board_state), do: Map.get(board_state, :positions)
  def positions(pid), do: pid |> current_state() |> positions()

  @doc """
  Gets the value at the given board position.

  ## Examples

      iex> {:ok, pid} = TicTacToe.Game.Board.start_link([])
      iex> TicTacToe.Game.Board.get(pid, 0)
      {:error, "out of range"}
      iex> TicTacToe.Game.Board.get(pid, 10)
      {:error, "out of range"}
      iex> TicTacToe.Game.Board.get(pid, 1)
      " "
  
  """
  def get(_pid, position) when is_nil(position), do: {:error, "no board position at nil"}
  def get(_pid, position) when is_integer(position) and position not in 1..9, do: {:error, "out of range"}
  def get(pid, position) when is_integer(position), do: pid |> positions |> Enum.at(position - 1)

  @doc """
  Puts the given `value` at the given `board` position.

  ## Examples

      iex> {:ok, pid} = TicTacToe.Game.Board.start_link([])
      iex> TicTacToe.Game.Board.put(pid, 0, X)
      {:error, "out of range"}
      iex> TicTacToe.Game.Board.put(pid, 10, X)
      {:error, "out of range"}

      iex> {:ok, pid} = TicTacToe.Game.Board.start_link([])
      iex> :ok = TicTacToe.Game.Board.put(pid, 2, "X")
      iex> %{positions: positions, history: history} = TicTacToe.Game.Board.current_state(pid)
      iex> positions
      [" ", "X", " ", " ", " ", " ", " ", " ", " "]
      iex> history
      [2]
  
  """
  def put(_pid, position, _value) when position not in 1..9, do: {:error, "out of range"}
  def put(pid, position, value) when is_integer(position) do
    Agent.update(pid, fn %{positions: positions, history: history} = state ->
      case Enum.member?(history, position) do
        true ->
          state
        false ->
          %TicTacToe.Game.Board{
            positions: List.replace_at(positions, position - 1, value),
            history: List.insert_at(history, -1, position)
          }
      end
    end)
  end

  @doc """
  Returns the last move.

  ## Examples

      iex> {:ok, pid} = TicTacToe.Game.Board.start_link([])
      iex> TicTacToe.Game.Board.put(pid, 4, "X")
      iex> TicTacToe.Game.Board.last_move(pid)
      {:ok, 4, "X"}

      iex> {:ok, pid} = TicTacToe.Game.Board.start_link([])
      iex> TicTacToe.Game.Board.last_move(pid)
      {:error, "no moves yet"}

  """
  def last_move(board) do
    last_position = board |> history() |> List.last()
    case get(board, last_position) do
      {:error, _msg} -> {:error, "no moves yet"}      
      token          -> {:ok, last_position, token}
    end
  end
end
