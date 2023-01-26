require Ash.Query

representative_1 = (
  Playground.Support.Representative
  |> Ash.Changeset.for_create(:create, %{name: "John Doe"})
  |> Playground.Support.create!()
)

representative_2 = (
  Playground.Support.Representative
  |> Ash.Changeset.for_create(:create, %{name: "Jane Doe"})
  |> Playground.Support.create!()
)

Playground.Support.Representative
|> Ash.Changeset.for_create(:create, %{name: "Joe Doe"})
|> Playground.Support.create!()

for i <- 1..1_000 do
  ticket =
    Playground.Support.Ticket
    |> Ash.Changeset.for_create(:open, %{subject: "Issue #{i}"})
    |> Playground.Support.create!()

  if rem(i, 5) == 0 do
    ticket
    |> Ash.Changeset.for_update(:assign, %{representative_id: representative_1.id})
    |> Playground.Support.update!()
  end

  if rem(i, 7) == 0 do
    ticket
    |> Ash.Changeset.for_update(:assign, %{representative_id: representative_2.id})
    |> Playground.Support.update!()
  end

  if rem(i, 4) == 0 do
    ticket
    |> Ash.Changeset.for_update(:close)
    |> Playground.Support.update!()
  end
end
