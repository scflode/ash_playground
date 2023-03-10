defmodule Playground.Support.Representative do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "representatives"
    repo Playground.Repo
  end

  actions do
    defaults [:create, :read, :update, :destroy]
  end

  attributes do
    uuid_primary_key :id
    attribute :name, :string
  end

  relationships do
    has_many :tickets, Playground.Support.Ticket
  end

  calculations do
    calculate :percent_open, :float, expr(open_tickets / total_tickets)
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
end
