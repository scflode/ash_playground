defmodule Playground.Accounts do
  use Ash.Api

  resources do
    registry Playground.Accounts.Registry
  end
end
