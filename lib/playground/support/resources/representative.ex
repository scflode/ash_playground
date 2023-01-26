defmodule Playground.Support.Representative do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "representatives"
    repo Playground.Repo
  end

  actions do
    defaults [:create, :read, :update, :destroy]

    read :filter_active do
      prepare build(limit: 10)
    end
  end

  attributes do
    uuid_primary_key :id
    attribute :name, :string
  end

  relationships do
    has_many :tickets, Playground.Support.Ticket
  end

  calculations do
    # See https://github.com/ash-project/ash_postgres/issues/128 type cast should not be needed
    calculate :percent_open,
              :float,
              expr(if(total_tickets > 0, type(open_tickets / total_tickets, :float), 100.0))
  end

  aggregates do
    count :total_tickets, :tickets

    count :open_tickets, :tickets do
      filter expr(status == :open)
    end

    count :closed_tickets, :tickets do
      filter expr(status == :closed)
    end
  end

  code_interface do
    define_for Playground.Support
    define :filter_active
  end
end
