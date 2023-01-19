defmodule Playground.Accounts.Registry do
  use Ash.Registry, extensions: [Ash.Registry.ResourceValidations]
  
  entries do
    entry Playground.Accounts.User
    entry Playground.Accounts.Token
  end
end
