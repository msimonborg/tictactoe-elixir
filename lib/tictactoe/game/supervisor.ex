defmodule TicTacToe.Game.Supervisor do
  @moduledoc """
  Supervises the game processes
  """

  use Supervisor

  @name TicTacToe.Game.Supervisor

  def start_link(_opts) do
    Supervisor.start_link(__MODULE__, :ok, name: @name)
  end

  def start_game do
    Supervisor.start_child(@name, [])
  end

  def init(:ok) do
    children = [
      TicTacToe.Game
    ]

    Supervisor.init(children, strategy: :simple_one_for_one)
  end
end
