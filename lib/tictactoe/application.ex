defmodule TicTacToe.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc """
  The game application module.
  """

  use Application

  def start(_type, _args) do
    children = [
      TicTacToe.Game.Supervisor,
      TicTacToe.CLI.Supervisor,
      {Task.Supervisor, name: TicTacToe.SimulationSupervisor}
    ]

    opts = [strategy: :one_for_one, name: TicTacToe.Application]
    Supervisor.start_link(children, opts)
  end
end
