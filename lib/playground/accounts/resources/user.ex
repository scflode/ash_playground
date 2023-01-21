defmodule Playground.Accounts.User do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAuthentication]

  attributes do
    uuid_primary_key :id
    attribute :email, :ci_string, allow_nil?: false
    attribute :hashed_password, :string, allow_nil?: false, sensitive?: true
  end

  authentication do
    api Playground.Accounts

    strategies do
      password :password do
        identity_field :email
      end
    end

    tokens do
      enabled? true
      store_all_tokens? true
      require_token_presence_for_authentication? true
      token_resource Playground.Accounts.Token

      signing_secret fn _, _ ->
        Application.fetch_env(:playground, :token_signing_secret)
      end
    end
  end

  postgres do
    table "users"
    repo Playground.Repo
  end

  identities do
    identity :unique_email, [:email]
  end
end
