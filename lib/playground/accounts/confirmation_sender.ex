defmodule Playground.Accounts.ConfirmationSender do
  use AshAuthentication.Sender
  import Swoosh.Email

  @impl true
  def send(user, token, _opts) do
    new()
    |> to(to_string(user.email))
    |> from({"Doc Brown", "emmet@brown.inc"})
    |> subject("Confirmation instructions")
    |> text_body("""
    Please confirm your account via the following link:
    http://localhost:4000/auth/user/confirm?#{URI.encode_query(confirm: token)}
    """)
    |> Playground.Mailer.deliver()

    :ok
  end
end
