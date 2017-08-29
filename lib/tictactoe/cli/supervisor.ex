defmodule TicTacToe.CLI.Supervisor do
  @moduledoc """
  Supervises the CLI processes
  """

  use Supervisor

  @doc false
  def start_link(_opts), do: Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)

  @doc false
  def init(:ok) do
    children = [
      {TicTacToe.CLI, name: TicTacToe.CLI}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
