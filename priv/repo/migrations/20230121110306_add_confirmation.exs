defmodule Playground.Repo.Migrations.AddConfirmation do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    alter table(:users) do
      modify :id, :uuid, default: fragment("uuid_generate_v4()")
      add :confirmed_at, :utc_datetime_usec
    end

    alter table(:tickets) do
      modify :id, :uuid, default: fragment("uuid_generate_v4()")
    end

    alter table(:representatives) do
      modify :id, :uuid, default: fragment("uuid_generate_v4()")
    end
  end

  def down do
    alter table(:representatives) do
      modify :id, :uuid, default: nil
    end

    alter table(:tickets) do
      modify :id, :uuid, default: nil
    end

    alter table(:users) do
      remove :confirmed_at
      modify :id, :uuid, default: nil
    end
  end
end