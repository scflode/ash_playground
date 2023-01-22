defmodule Playground.Support.Registry do
  use Ash.Registry,
    extensions: [
      Ash.Registry.ResourceValidations,
      AshPaperTrail.Registry
    ]

  entries do
    entry Playground.Support.Ticket
    entry Playground.Support.Representative
  end
end
