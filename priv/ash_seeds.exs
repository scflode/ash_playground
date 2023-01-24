require Ash.Query

representative = (
  Playground.Support.Representative
  |> Ash.Changeset.for_create(:create, %{name: "Joe Armstrong"})
  |> Playground.Support.create!()
)

for i <- 1..50_000 do
  ticket =
    Playground.Support.Ticket
    |> Ash.Changeset.for_create(:open, %{subject: "Issue #{i}"})
    |> Playground.Support.create!()

  if rem(i, 5) == 0 do
    ticket
    |> Ash.Changeset.for_update(:assign, %{representative_id: representative.id})
    |> Playground.Support.update!()
  end

  if rem(i, 4) == 0 do
    ticket
    |> Ash.Changeset.for_update(:close)
    |> Playground.Support.update!()
  end
end
