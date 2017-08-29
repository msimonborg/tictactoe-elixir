defmodule TicTacToe.Game.BoardTest do
  use ExUnit.Case, async: true
  alias TicTacToe.Game.Board
  doctest Board

  setup do
    {:ok, board} = Board.start_link([])
    %{board: board}
  end

  test "initializes the board state", %{board: board} do
    assert {[" ", " ", " ", " ", " ", " ", " ", " ", " "], []} == Board.current_state(board)
  end

  test "gets a value from the board state", %{board: board} do
    assert Board.get(board, 1) == " "
  end

  test "puts a value into the board state", %{board: board} do
    Board.put(board, 1, "X")
    
    assert Board.get(board, 1) == "X"
    assert Board.get(board, 2) == " "
  end

  test "gets the board history", %{board: board} do
    Board.put(board, 1, "X")
    Board.put(board, 9, "O")

    assert Board.history(board) == [1, 9]
  end
end