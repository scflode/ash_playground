defmodule Playground.Support.Registry do
  use Ash.Registry,
    extensions: [
      Ash.Registry.ResourceValidations
    ]

  entries do
    entry Playground.Support.Ticket
    entry Playground.Support.RawTicket
    entry Playground.Support.Representative
  end
end
