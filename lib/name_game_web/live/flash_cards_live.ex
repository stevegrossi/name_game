defmodule NameGameWeb.FlashCardsLive do
  use Phoenix.LiveView

  def mount(_params, _session, socket) do
    data = load_data()
    socket = assign(socket, :people, data)
    socket = assign(socket, :count, 1)
    socket = assign(socket, :done, false)
    socket = assign(socket, :current_person, List.first(data))
    socket = assign(socket, :revealed, false)
    socket = assign(socket, :total, Enum.count(data))

    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <div class="stage">
      <div class="count">
        <%= @count %> / <%= @total %>
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

  def handle_event("next", _event, %{assigns: %{count: _same, total: _same}} = socket) do
    socket = assign(socket, :done, true)
    {:noreply, socket}
  end
  def handle_event("next", _event, socket) do
    updated_people = Enum.reject(socket.assigns.people, fn(person) ->
      person.photo == socket.assigns.current_person.photo
    end)
    socket = update(socket, :count, &(&1 + 1))
    socket = assign(socket, :revealed, false)
    socket = assign(socket, :people, updated_people)
    socket = assign(socket, :current_person, Enum.random(updated_people))
    {:noreply, socket}
  end

  def handle_event("reveal", _event, socket) do
    socket = assign(socket, :revealed, true)
    {:noreply, socket}
  end

  defp load_data() do
    ConCache.get_or_store(:data_cache, :data, fn() ->
      HTTPoison.start
      response = HTTPoison.get!("https://www.lessonly.com/team/")
      {:ok, document} = Floki.parse_document(response.body)
      members = Floki.find(document, ".team-member")
      Enum.map(members, fn(member_node) ->
        [photo] = Floki.attribute(member_node, ".team-member-photo .photo-hover", "data-src")
        name = Floki.find(member_node, ".team-member-name") |> Floki.text
        title = Floki.find(member_node, ".team-member-title") |> Floki.text
        %{
          name: name,
          title: title,
          photo: photo
        }
      end)
    end)
  end
end

