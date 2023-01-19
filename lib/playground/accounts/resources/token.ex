defmodule Playground.Accounts.Token do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAuthentication.TokenResource]

  token do
    api Playground.Accounts
  end

  postgres do
    table "tokens"
    repo Playground.Repo
  end
end
