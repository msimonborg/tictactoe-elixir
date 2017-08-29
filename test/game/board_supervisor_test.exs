defmodule TicTacToe.Game.BoardSupervisorTest do
  use ExUnit.Case, async: true
  alias TicTacToe.Game.BoardSupervisor
  alias TicTacToe.Game.Board

  test "starts a new board" do
    {:ok, board} = BoardSupervisor.start_board

    Board.put(board, 1, "X")
    assert Board.get(board, 1) == "X"
  end
end