defmodule Playground.Support.Ticket do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshArchival.Resource]

  postgres do
    table "tickets"
    repo(Playground.Repo)
  end

  actions do
    defaults [:create, :update, :destroy]

    read :read do
      primary? true
    end

    create :open do
      accept [:subject]
    end

    update :assign do
      accept []

      argument :representative_id, :uuid do
        allow_nil? false
      end

      change manage_relationship(:representative_id, :representative, type: :append_and_remove)
    end

    update :close do
      accept []
      change set_attribute(:status, :closed)
    end

    create :unarchive do
      manual? true

      argument :id, :uuid do
        allow_nil? false
      end

      accept [:id]

      change Playground.Support.Resources.Changes.Unarchive
    end

    read :filter_open do
      prepare build(limit: 10)
      filter expr(status == :open)
    end

    read :filter_closed do
      prepare build(limit: 10)
      filter expr(status == :closed)
    end

    read :filter do
      argument :status, :atom do
        constraints one_of: [:all, :open, :closed]
        default :all
        allow_nil? true
        description "The status to filter"
      end

      prepare build(sort: :subject)
      pagination offset?: true, default_limit: 10, required?: true, countable: true
      filter expr(status == ^arg(:status) or :all == ^arg(:status))
    end
  end

  attributes do
    uuid_primary_key :id

    attribute :subject, :string do
      allow_nil? false
    end

    attribute :status, :atom do
      constraints one_of: [:open, :closed]
      default :open
      allow_nil? false
    end
  end

  relationships do
    belongs_to :representative, Playground.Support.Representative
  end

  calculations do
    calculate :subject_and_status, :string, expr(subject <> ^arg(:separator) <> status) do
      argument :separator, :string do
        allow_nil? false
        default " "
      end
    end
  end

  code_interface do
    define_for Playground.Support
    define :open, args: [:subject]
    define_calculation :subject_and_status, args: [:subject, :status, {:optional, :separator}]
    define :unarchive, args: [:id]
    define :filter, args: [:status]
    define :filter_open
    define :filter_closed
  end
end
