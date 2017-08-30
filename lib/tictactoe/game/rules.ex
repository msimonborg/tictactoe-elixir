defmodule TicTacToe.Game.Rules do
@moduledoc """
Defines the game rules.
"""

import Enum, only: [all?: 2, find: 3, at: 2, any?: 2]

  @win_combos [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 4, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [2, 4, 6]
  ]
  # @corners [0, 2, 6, 8]
  # @sides [1, 3, 5, 7]
  # @center 4

  @doc """
  Returns a boolean value indicating whether or not the board is full.

  ## Examples

      iex> board_positions = List.duplicate(" ", 9)
      iex> TicTacToe.Game.Rules.full?(board_positions)
      false

      iex> board_positions = " " |> List.duplicate(9) |> List.replace_at(4, "X")
      iex> TicTacToe.Game.Rules.full?(board_positions)
      false

      iex> board_positions = List.duplicate("X", 9)
      iex> TicTacToe.Game.Rules.full?(board_positions)
      true
  
  """
  def full?(board_positions), do: !any?(board_positions, &(&1 == " "))

  @doc """
  Returns a boolean value indicating whether or not the game is won.

  ## Examples

      iex> board_positions = List.duplicate(" ", 9)
      iex> TicTacToe.Game.Rules.winning_combo(board_positions)
      nil

      iex> board_positions = " " |> List.duplicate(9) |> List.replace_at(4, "X")
      iex> TicTacToe.Game.Rules.winning_combo(board_positions)
      nil

      iex> board_positions = [" ", " ", "X", "O", "X", "O", "X", " ", " "]
      iex> TicTacToe.Game.Rules.winning_combo(board_positions)
      [2, 4, 6]
  
  """
  def winning_combo(board_positions) do
    find(@win_combos, nil, fn combo ->
      all?(combo, &(at(board_positions, &1) == "X")) || 
        all?(combo, &(at(board_positions, &1) == "O"))
    end)
  end

  @doc """
  Returns a `boolean` indicating if the game is won.

  ## Examples

      iex> pos = List.duplicate(" ", 9)
      iex> TicTacToe.Game.Rules.won?(pos)
      false

      iex> pos = " " |> List.duplicate(9) |> List.replace_at(4, "X")
      iex> TicTacToe.Game.Rules.won?(pos)
      false

      iex> pos = [" ", " ", "X", "O", "X", "O", "X", " ", " "]
      iex> TicTacToe.Game.Rules.won?(pos)
      true
  
  """
  def won?(board_positions), do: !!winning_combo(board_positions)

  @doc """
  Returns a `boolean` indicating if the game is a draw.

  ## Examples

      iex> pos = List.duplicate(" ", 9)
      iex> TicTacToe.Game.Rules.draw?(pos)
      false

      iex> pos = " " |> List.duplicate(9) |> List.replace_at(4, "X")
      iex> TicTacToe.Game.Rules.draw?(pos)
      false

      iex> pos = [" ", " ", "X", "O", "X", "O", "X", " ", " "]
      iex> TicTacToe.Game.Rules.draw?(pos)
      false

      iex> pos = ["X", "O", "X", "O", "X", "O", "X", "O", "X"]
      iex> TicTacToe.Game.Rules.draw?(pos)
      false

      iex> pos = ["X", "X", "O", "O", "O", "X", "X", "O", "X"]
      iex> TicTacToe.Game.Rules.draw?(pos)
      true

  """
  def draw?(board_positions), do: full?(board_positions) && !won?(board_positions)

  @doc """
  Returns a `boolean` indicating if the game is over.

  ## Examples

      iex> pos = List.duplicate(" ", 9)
      iex> TicTacToe.Game.Rules.over?(pos)
      false

      iex> pos = " " |> List.duplicate(9) |> List.replace_at(4, "X")
      iex> TicTacToe.Game.Rules.over?(pos)
      false

      iex> pos = [" ", " ", "X", "O", "X", "O", "X", " ", " "]
      iex> TicTacToe.Game.Rules.over?(pos)
      true

      iex> pos = ["X", "O", "X", "O", "X", "O", "X", "O", "X"]
      iex> TicTacToe.Game.Rules.over?(pos)
      true

      iex> pos = ["X", "X", "O", "O", "O", "X", "X", "O", "X"]
      iex> TicTacToe.Game.Rules.over?(pos)
      true
  
  """
  def over?(board_positions), do: draw?(board_positions) || won?(board_positions)
end