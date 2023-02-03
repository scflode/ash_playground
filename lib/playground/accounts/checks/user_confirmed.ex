defmodule Playground.Accounts.Checks.UserConfirmed do
  use Ash.Policy.SimpleCheck

  alias Playground.Accounts.User

  def describe(_) do
    "user is confirmed"
  end

  def match?(%User{confirmed_at: confirmed_at}, _context, _options) do
    not is_nil(confirmed_at)
  end

  def match?(_, _, _), do: false
end
