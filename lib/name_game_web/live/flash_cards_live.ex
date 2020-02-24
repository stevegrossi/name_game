defmodule NameGameWeb.FlashCardsLive do
  use Phoenix.LiveView

  def mount(_params, _session, socket) do
    data =
      ConCache.get_or_store(:data_cache, :data, fn() ->
        fetch_data()
      end)

    socket = assign(socket, :people, data)
    socket = assign(socket, :count, 1)
    socket = assign(socket, :current, List.first(socket.assigns.people).name)
    socket = assign(socket, :revealed, false)
    {:ok, socket}
  end

  def render(assigns) do
    current =
      Enum.find(assigns.people, fn(person) ->
        person.name == assigns.current
      end)

    ~L"""
    <div class="stage">
      <div class="count">
        <%= @count %> / <%= Enum.count(@people) %>
      </div>
      <img class="photo" src="<%= current.photo %>" alt="" />
      <div class="placeholder <%= if not @revealed, do: "revealed" %>">?</div>
      <div class="namecard <%= if @revealed, do: "revealed" %>">
        <h2><%= current.name %></h2>
        <p><%= current.title %></p>
      </div>
    </div>
    <p class="buttons">
      <%= if @revealed do %>
        <button class="button" phx-click="shuffle">Another!</button>
      <% else %>
        <button class="button" phx-click="reveal">Show me!</button>
      <% end %>
    </p>
    """
  end

  def handle_event("shuffle", _event, socket) do
    socket = update(socket, :count, &(&1 + 1))
    socket = assign(socket, :revealed, false)
    socket = assign(socket, :current, Enum.random(socket.assigns.people).name)
    {:noreply, socket}
  end

  def handle_event("reveal", _event, socket) do
    socket = assign(socket, :revealed, true)
    {:noreply, socket}
  end

  defp fetch_data() do
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
  end
end

