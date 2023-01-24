defmodule PlaygroundWeb.Components.Pagination do
  use Phoenix.Component

  attr :current_start, :integer, required: true
  attr :current_end, :integer, required: true
  attr :total_items, :integer, required: true
  attr :path, :string, required: true

  @pages_around 2

  def default(assigns) do
    limit = assigns[:current_end] - assigns[:current_start]
    current_page = ceil(assigns[:current_end] / limit)
    total_pages = ceil(assigns[:total_items] / limit)

    assigns =
      assigns
      |> assign_new(:current_page, fn -> current_page end)
      |> assign_new(:total_pages, fn -> total_pages end)
      |> assign_new(:pages, fn -> build_pages(current_page, total_pages) end)

    ~H"""
    <div class="flex items-center justify-between border-t border-gray-200 bg-white px-4 py-3 sm:px-6">
      <%!-- Mobile pagination --%>
      <div class="flex flex-1 justify-between sm:hidden">
        <.link
          :if={@current_page > 1}
          navigate={paged_path(@path, @current_page - 1)}
          class="relative inline-flex items-center rounded-md border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50"
        >
          Previous
        </.link>
        <span
          :if={@current_page == 1}
          class="relative inline-flex items-center rounded-md border border-gray-100 bg-white px-4 py-2 text-sm font-medium text-gray-400"
        >
          Previous
        </span>
        <.link
          :if={@current_page < @total_pages}
          navigate={paged_path(@path, @current_page + 1)}
          class="relative ml-3 inline-flex items-center rounded-md border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50"
        >
          Next
        </.link>
        <span
          :if={@current_page == @total_pages}
          class="relative inline-flex items-center rounded-md border border-gray-100 bg-white px-4 py-2 text-sm font-medium text-gray-400"
        >
          Next
        </span>
      </div>
      <%!-- Desktop pagination --%>
      <div class="hidden sm:flex sm:flex-1 sm:items-center sm:justify-between">
        <div>
          <p class="text-sm text-gray-700">
            Showing
            <span class="font-medium">
              <%= @current_start + 1 %>
            </span>
            to
            <span class="font-medium">
              <%= @current_end %>
            </span>
            of
            <span class="font-medium">
              <%= @total_items %>
            </span>
            results
          </p>
        </div>
        <div>
          <nav class="isolate inline-flex -space-x-px rounded-md shadow-sm" aria-label="Pagination">
            <.link
              :if={@current_page > 1}
              navigate={paged_path(@path, @current_page - 1)}
              class="relative inline-flex items-center rounded-l-md border border-gray-300 bg-white px-2 py-2 text-sm font-medium text-gray-500 hover:bg-gray-50 focus:z-20"
            >
              <span class="sr-only">Previous</span>
              <Heroicons.chevron_left mini class="w-5 h-5" />
            </.link>
            <.pagination_link
              :for={page <- @pages}
              current_page={@current_page}
              page={page}
              path={@path}
            />
            <.link
              :if={@current_page < @total_pages}
              navigate={paged_path(@path, @current_page + 1)}
              class="relative inline-flex items-center rounded-r-md border border-gray-300 bg-white px-2 py-2 text-sm font-medium text-gray-500 hover:bg-gray-50 focus:z-20"
            >
              <span class="sr-only">Next</span>
              <Heroicons.chevron_right mini class="w-5 h-5" />
            </.link>
          </nav>
        </div>
      </div>
    </div>
    """
  end

  defp pagination_link(assigns) do
    ~H"""
    <span
      :if={@current_page == @page}
      aria-current="page"
      class={[
        "relative z-10 focus:z-20 inline-flex items-center px-4 py-2",
        "border-indigo-500 bg-indigo-50 text-indigo-600",
        "border text-sm font-medium"
      ]}
    >
      <%= @page %>
    </span>
    <span
      :if={@page == "..."}
      class={[
        "relative inline-flex items-center px-4 py-2 focus:z-20",
        "border-gray-300 bg-white text-gray-500 hover:bg-gray-50",
        "border text-sm font-medium"
      ]}
    >
      ...
    </span>
    <.link
      :if={@current_page != @page and @page != "..."}
      navigate={paged_path(@path, @page)}
      class={[
        "relative inline-flex items-center px-4 py-2 focus:z-20",
        "border-gray-300 bg-white text-gray-500 hover:bg-gray-50",
        "border text-sm font-medium"
      ]}
    >
      <%= @page %>
    </.link>
    """
  end

  # Append the page parameter to the path
  defp paged_path(path, page) do
    path
    |> URI.parse()
    |> URI.append_query(URI.encode_query(%{page: page}))
    |> URI.to_string()
  end

  defp build_pages(current_page, total_pages) do
    cond do
      # No truncation
      total_pages <= @pages_around * 2 + 1 + 1 + 1 ->
        Enum.to_list(1..total_pages)

      # Right side truncation
      # first + pages around + last
      current_page <= 1 + @pages_around + 1 ->
        [
          Enum.to_list(1..(current_page + @pages_around)),
          "...",
          total_pages
        ]
        |> List.flatten()

      # Left side truncation
      # total pages - pages around - first - last
      current_page > total_pages - @pages_around - 1 - 1 ->
        [
          1,
          "...",
          Enum.to_list((current_page - @pages_around)..total_pages)
        ]
        |> List.flatten()

      # Truncation on both sides
      true ->
        [
          1,
          "...",
          Enum.to_list((current_page - @pages_around)..(current_page - 1)),
          current_page,
          Enum.to_list((current_page + 1)..(current_page + @pages_around)),
          "...",
          total_pages
        ]
        |> List.flatten()
    end
  end
end
