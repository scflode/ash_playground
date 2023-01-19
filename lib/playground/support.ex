defmodule Playground.Support do
  use Ash.Api

  resources do
    registry Playground.Support.Registry
  end
end
