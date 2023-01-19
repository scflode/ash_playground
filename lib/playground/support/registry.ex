defmodule Playground.Support.Registry do
  use Ash.Registry,
    extensions: [
      # This extension adds helpful compile time validations
      Ash.Registry.ResourceValidations
    ]

  entries do
    entry Playground.Support.Ticket
    entry Playground.Support.Representative
  end
end
