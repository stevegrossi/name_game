defmodule NameGameWeb.FlashCardsLive do
  use Phoenix.LiveView, layout: {NameGameWeb.LayoutView, "live.html"}

  alias NameGame.Store

  def mount(_params, _session, socket) do
    [current_person | remaining_people] = load_people()

    socket =
      assign(socket,
        people: remaining_people,
        done: false,
        current_person: current_person,
        revealed: false,
        total: length(remaining_people) + 1
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <div class="stage">
      <div class="count">
        <%= @total - length(@people) %> / <%= @total %>
      </div>
      <%= if @done do %>
        <div class="done">
          <h2>That’s everyone!</h2>
          <p>Feeling ambitious? Refresh the page to start over!</p>
        </div>
      <% else %>
        <img class="photo" src="<%= @current_person.photo %>" alt="" />
        <div class="placeholder <%= if not @revealed, do: "revealed" %>">?</div>
        <div class="namecard <%= if @revealed, do: "revealed" %>">
          <h2><%= @current_person.name %></h2>
          <p><%= @current_person.title %></p>
        </div>
      <% end %>
    </div>
    <%= if not @done do %>
      <p class="buttons">
        <%= if @revealed do %>
          <button id="next" class="button" phx-click="next">Another!</button>
        <% else %>
          <button id="reveal" class="button" phx-click="reveal">Show me!</button>
        <% end %>
      </p>
    <% end %>
    """
  end

  def handle_event("next", _event, %{assigns: %{people: []}} = socket) do
    socket = assign(socket, :done, true)
    {:noreply, socket}
  end

  def handle_event("next", _event, socket) do
    [current_person | remaining_people] = socket.assigns.people

    socket =
      assign(socket,
        revealed: false,
        current_person: current_person,
        people: remaining_people
      )

    {:noreply, socket}
  end

  def handle_event("reveal", _event, socket) do
    socket = assign(socket, :revealed, true)
    {:noreply, socket}
  end

  defp load_people() do
    Store.get_people()
    |> Enum.shuffle()
  end
end
