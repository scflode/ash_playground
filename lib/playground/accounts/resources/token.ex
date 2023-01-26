defmodule Playground.Accounts.Token do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAuthentication.TokenResource]

  postgres do
    table "tokens"
    repo Playground.Repo
  end

  token do
    api Playground.Accounts
  end
end
