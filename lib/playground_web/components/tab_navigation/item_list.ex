defmodule PlaygroundWeb.Components.TabNavigation.ItemList do
  alias PlaygroundWeb.Components.TabNavigation.Item

  @type t(entries) :: %__MODULE__{entries: entries}
  @type t :: %__MODULE__{entries: list(%Item{})}

  @enforce_keys [:entries]
  defstruct [:entries]
end
