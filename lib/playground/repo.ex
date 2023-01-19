defmodule Playground.Repo do
  use AshPostgres.Repo,
    otp_app: :playground
end
