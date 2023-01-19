defmodule Playground.Support do
  use Ash.Api

  resources do
    # This defines the set of resources that can be used with this API
    registry Playground.Support.Registry
  end

end
