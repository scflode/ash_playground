defmodule Playground.Support do
  use Ash.Api,
    extensions: [AshAdmin.Api]

  admin do
    show?(true)
  end

  resources do
    registry Playground.Support.Registry
  end
end
