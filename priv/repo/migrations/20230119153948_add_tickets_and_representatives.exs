defmodule Playground.Repo.Migrations.AddTicketsAndRepresentatives do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    create table(:tickets, primary_key: false) do
      add :id, :uuid, null: false, primary_key: true
      add :subject, :text, null: false
      add :status, :text, null: false, default: "open"
      add :representative_id, :uuid
    end

    create table(:representatives, primary_key: false) do
      add :id, :uuid, null: false, primary_key: true
    end

    alter table(:tickets) do
      modify :representative_id,
             references(:representatives,
               column: :id,
               prefix: "public",
               name: "tickets_representative_id_fkey",
               type: :uuid
             )
    end

    alter table(:representatives) do
      add :name, :text
    end
  end

  def down do
    alter table(:representatives) do
      remove :name
    end

    drop constraint(:tickets, "tickets_representative_id_fkey")

    alter table(:tickets) do
      modify :representative_id, :uuid
    end

    drop table(:representatives)

    drop table(:tickets)
  end
end
