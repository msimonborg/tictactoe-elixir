defmodule TicTacToe.Game.Supervisor do
  @moduledoc """
  Supervises the game processes
  """

  use Supervisor

  @doc false
  def start_link(_opts) do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @doc """
  Start a new supervised game.
  """
  def start_game do
    Supervisor.start_child(__MODULE__, [])
  end

  @doc false
  def init(:ok) do
    children = [
      TicTacToe.Game
    ]

    Supervisor.init(children, strategy: :simple_one_for_one)
  end
end
