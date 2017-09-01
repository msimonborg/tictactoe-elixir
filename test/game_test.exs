defmodule TicTacToe.GameTest do
  use ExUnit.Case, async: true
  alias TicTacToe.Game
  alias TicTacToe.Game.Board

  doctest Game

  setup do
    {:ok, game} = start_supervised(Game)
    %{game: game}
  end

  test "initializes a linked board", %{game: game} do
    board_state = game |> Game.board() |> Board.current_state()
    assert board_state == %TicTacToe.Game.Board{}
  end

  test "makes a move and returns the board state", %{game: game} do
    board_state = Game.move(game, 4, "X")
    assert Map.get(board_state, :positions) == [" ", " ", " ", "X", " ", " ", " ", " ", " "]
    assert Map.get(board_state, :history) == [4]
    assert board_state == game |> Game.board() |> Board.current_state()
  end

  test "knows the current player", %{game: game} do
    Game.move(game, 4, "X")
    assert Game.current_player(game) == "O"

    Game.move(game, 5, "O")
    assert Game.current_player(game) == "X"
  end

  test "only allows players to move in the correct order", %{game: game} do
    %{positions: positions, history: history} = Game.move(game, 4, "X")
    assert history == [4]
    assert Game.current_player(game) == "O"

    assert Game.move(game, 5, "X") == {:error, "play out of turn"}
    assert Enum.at(positions, 5) == " "
  end
end