require Ash.Query

representative = (
  Playground.Support.Representative
  |> Ash.Changeset.for_create(:create, %{name: "Joe Armstrong"})
  |> Playground.Support.create!()
)

for i <- 0..5 do
  ticket =
    Playground.Support.Ticket
    |> Ash.Changeset.for_create(:open, %{subject: "Issue #{i}"})
    |> Playground.Support.create!()
    |> Ash.Changeset.for_update(:assign, %{representative_id: representative.id})
    |> Playground.Support.update!()

  if rem(i, 2) == 0 do
    ticket
    |> Ash.Changeset.for_update(:close)
    |> Playground.Support.update!()
  end
end
