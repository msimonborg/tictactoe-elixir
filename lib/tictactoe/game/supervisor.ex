defmodule TicTacToe.Game.Supervisor do
  @moduledoc """
  Supervises the game processes
  """

  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    children = [
      # TicTacToe.Game
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
