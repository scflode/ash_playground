defmodule Playground.Accounts.User do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAuthentication]

  postgres do
    table "users"
    repo Playground.Repo
  end

  actions do
    read :read do
      primary? true

      prepare build(load: [:confirmed?])
    end
  end

  attributes do
    uuid_primary_key :id
    attribute :email, :ci_string, allow_nil?: false
    attribute :hashed_password, :string, allow_nil?: false, sensitive?: true
  end

  calculations do
    calculate :confirmed?, :boolean, expr(not is_nil(confirmed_at))
  end

  identities do
    identity :unique_email, [:email], eager_check_with: Playground.Accounts
  end

  authentication do
    api Playground.Accounts

    strategies do
      password :password do
        identity_field :email
      end
    end

    add_ons do
      confirmation :confirm do
        monitor_fields [:email]
        sender Playground.Accounts.ConfirmationSender
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
end
