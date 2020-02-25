defmodule NameGame.Store do

  @team_page "https://www.lessonly.com/team/"
  @person_selector ".team-member"
  @photo_selector ".team-member-photo .photo-hover"
  @name_selector ".team-member-name"
  @title_selector ".team-member-title"
  @ignored_names ["Ollie Llama"]

  def get_people() do
    ConCache.get_or_store(:data_cache, :data, fn() ->
      HTTPoison.start
      response = HTTPoison.get!(@team_page)
      {:ok, document} = Floki.parse_document(response.body)

      document
      |> Floki.find(@person_selector)
      |> Enum.map(fn(member_node) ->
          [photo] = Floki.attribute(member_node, @photo_selector, "data-src")
          name = Floki.find(member_node, @name_selector) |> Floki.text
          title = Floki.find(member_node, @title_selector) |> Floki.text
          %{
            name: name,
            title: title,
            photo: photo
          }
        end)
      |> Enum.reject(&(&1.name in @ignored_names))
    end)
  end
end
