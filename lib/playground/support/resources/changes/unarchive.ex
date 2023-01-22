defmodule Playground.Support.Resources.Changes.Unarchive do
  use Ash.Resource.Change
  require Ash.Query

  alias Playground.Support
  alias Playground.Support.RawTicket

  def change(changeset, _, _) do
    Ash.Changeset.after_action(changeset, fn changeset, nil ->
      id = Ash.Changeset.get_argument(changeset, :id)

      RawTicket
      |> Support.get!(id)
      |> Ash.Changeset.for_update(:update, %{archived_at: nil})
      |> Support.update!()

      {:ok, Support.get!(changeset.resource, id)}
    end)
  end
end
