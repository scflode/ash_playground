defmodule Playground.Support.Ticket do
  # This turns this module into a resource
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshArchival.Resource]

  postgres do
    table "tickets"
    repo Playground.Repo
  end

  actions do
    # Add a set of simple actions. You'll customize these later.
    defaults [:create, :read, :update, :destroy]

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
  end

  # Attributes are the simple pieces of data that exist on your resource
  attributes do
    # Add an autogenerated UUID primary key called `:id`.
    uuid_primary_key :id

    # Add a string type attribute called `:subject`
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
  end
end
