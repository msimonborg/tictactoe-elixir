defmodule TicTacToe.Game.Supervisor do
  @moduledoc """
  Supervises the game processes
  """

  use Supervisor, restart: :permanent

  @doc false
  def start_link(_opts), do: Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)

  @doc """
  Start a new supervised game.

  ## Examples

      iex> {:ok, game_pid} = TicTacToe.Game.Supervisor.start_game
      iex> game_pid |> TicTacToe.Game.board() |> TicTacToe.Game.Board.current_state()
      %TicTacToe.Game.Board{
        positions: [" ", " ", " ", " ", " ", " ", " ", " ", " "],
        history: []
      }

  """
  def start_game, do: Supervisor.start_child(__MODULE__, [])

  def stop_game(game), do: Supervisor.terminate_child(__MODULE__, game)

  @doc false
  def init(:ok) do
    children = [
      TicTacToe.Game
    ]

    Supervisor.init(children, strategy: :simple_one_for_one)
  end
end
