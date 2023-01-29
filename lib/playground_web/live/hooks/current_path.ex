defmodule PlaygroundWeb.Hooks.CurrentPath do
  import Phoenix.LiveView
  import Phoenix.Component

  def on_mount(:default, _params, _session, socket) do
    {:cont, attach_hook(socket, :current_path, :handle_params, &set_current_path_info/3)}
  end

  defp set_current_path_info(_params, url, socket) do
    path_info = URI.parse(url)
    {:cont, assign(socket, :current_path_info, path_info)}
  end
end
