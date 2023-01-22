defmodule Playground.Repo do
  use AshPostgres.Repo,
    otp_app: :playground

  def installed_extensions do
    ["citext", "uuid-ossp"]
  end
end
