defmodule LiveViewStudioWeb.LightLive do
  use LiveViewStudioWeb, :live_view

  @bulb "bulb"

  def mount(_params, _session, socket) do
    if connected?(socket) do
      LiveViewStudioWeb.Endpoint.subscribe(@bulb)
    end
    socket = assign(
      socket, %{
        brightness: 10,
        name: "Front door",
      })
    {:ok, socket}
  end

  def handle_event("on", _, socket) do
    socket = assign(socket, :brightness, 100)
    LiveViewStudioWeb.Endpoint.broadcast(@bulb, "brightness", %{brightness: socket.assigns.brightness})
    {:noreply, socket}
  end

  def handle_event("off", _, socket) do
    socket = assign(socket, :brightness, 0)
    LiveViewStudioWeb.Endpoint.broadcast(@bulb, "brightness", %{brightness: socket.assigns.brightness})
    {:noreply, socket}
  end

  def handle_event("down", _, socket) do
    socket = update(socket, :brightness, &max(&1 - 10, 0))
    LiveViewStudioWeb.Endpoint.broadcast(@bulb, "brightness", %{brightness: socket.assigns.brightness})
    {:noreply, socket}
  end

  def handle_event("up", _, socket) do
    socket = update(socket, :brightness, &min(&1 + 10, 100))
    LiveViewStudioWeb.Endpoint.broadcast(@bulb, "brightness", %{brightness: socket.assigns.brightness})
    {:noreply, socket}
  end

  def handle_info(%{topic: @bulb, event: "brightness", payload: payload}, socket) do
    {:noreply, assign(socket, :brightness, payload.brightness)}
  end

  def render(assigns) do
    ~H"""
    <div id="light">
    <h1><%= @name %></h1>
      <div class="meter">
        <span style={"width: #{@brightness}%"}>
          <%= @brightness %>%
        </span>
      </div>

      <button phx-click="off">
        Off
      </button>

      <button phx-click="down">
        Down
      </button>

      <button phx-click="up">
        Up
      </button>

      <button phx-click="on">
        On
      </button>
    </div>
    """
  end
end
