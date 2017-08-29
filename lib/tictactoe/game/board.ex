defmodule TicTacToe.Game.Board do
  @moduledoc """
  Manages the game board state.
  """

  use Agent, restart: :temporary

  @doc """
  Starts a new game board, a tuple with two lists. 
  
  The first list represents the value of each board square,
  initialized with nine elements all set to `" "`.

  The second list is the game history, or the order in which
  each move was made.
  """
  def start_link(_opts) do
    Agent.start_link(fn ->
      {
        [" ", " ", " ", " ", " ", " ", " ", " ", " "],
        []
      }
    end)
  end

  @doc """
  Returns the current board state.
  """
  def current_state(board) do
    Agent.get(board, &(&1))
  end

  @doc """
  Returns the board history.
  """
  def history(board) do
    Agent.get(board, &(elem(&1, 1)))
  end

  @doc """
  Gets the value at the given board position.
  """
  def get(_board, position) when position > 9, do: :error
  def get(_board, position) when position < 1, do: :error
  def get(board, position) when is_integer(position) do
    Agent.get(board, &Enum.at(elem(&1, 0), position - 1))
  end


  @doc """
  Puts the given `value` at the given `board` position.
  """
  def put(_board, position, _value) when position > 9, do: :error
  def put(_board, position, _value) when position < 1, do: :error
  def put(board, position, value) when is_integer(position) do
    Agent.update(board, fn {positions, history} ->
      {List.replace_at(positions, position - 1, value), List.insert_at(history, -1, position)}
    end)
  end
end