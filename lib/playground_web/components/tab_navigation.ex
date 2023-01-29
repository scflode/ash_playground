defmodule PlaygroundWeb.Components.TabNavigation do
  use Phoenix.Component

  alias Phoenix.LiveView.JS

  attr :items, :list,
    default: [%{to: "/", label: "My Label"}],
    doc: "A list of maps in the form of [%{to: ~p\"/my_path\", label: \"My label\"}]"

  attr :path_info, URI, required: true, doc: "A URI struct for the current path info"

  def underlined(assigns) do
    ~H"""
    <div>
      <div class="sm:hidden">
        <label for="tabs" class="sr-only">Select a tab</label>
        <select
          phx-change={
            JS.dispatch("js:nav-selected", detail: %{selectElId: "tabs-mobile", navElId: "tabs"})
          }
          id="tabs-mobile"
          name="tabs"
          class="block w-full rounded-md border-gray-300 py-2 pl-3 pr-10 text-base focus:border-indigo-500 focus:outline-none focus:ring-indigo-500 sm:text-sm"
        >
          <.select_item :for={item <- @items} to={item.to} label={item.label} path_info={@path_info} />
        </select>
      </div>
      <div class="hidden sm:block">
        <div class="border-b border-gray-200">
          <nav class="-mb-px flex space-x-8" aria-label="Tabs" id="tabs">
            <.item :for={item <- @items} to={item.to} label={item.label} path_info={@path_info} />
          </nav>
        </div>
      </div>
    </div>
    """
  end

  defp select_item(assigns) do
    assigns =
      assigns
      |> assign_new(:selected, fn ->
        if assigns[:to] == assigns[:path_info].path, do: true, else: false
      end)

    ~H"""
    <option :if={@selected} selected><%= @label %></option>
    <option :if={not @selected} value={@to}><%= @label %></option>
    """
  end

  defp item(assigns) do
    ~H"""
    <span
      :if={@path_info.path == @to}
      class={[
        "whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm",
        "border-indigo-500 text-indigo-600"
      ]}
    >
      <%= @label %>
    </span>
    <.link
      :if={@path_info.path != @to}
      navigate={@to}
      class={[
        "whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm",
        "border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300"
      ]}
      title={@label}
    >
      <%= @label %>
    </.link>
    """
  end
end
