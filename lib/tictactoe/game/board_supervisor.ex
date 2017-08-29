defmodule TicTacToe.Game.BoardSupervisor do
  @moduledoc """
  Supervises the game boards.
  """

  use Supervisor

  @name BoardSupervisor

  def start_link(_opts) do
    Supervisor.start_link(__MODULE__, :ok, name: @name)
  end

  def start_board do
    Supervisor.start_child(@name, [])
  end

  def init(:ok) do
    Supervisor.init([TicTacToe.Game.Board], strategy: :simple_one_for_one)
  end
end