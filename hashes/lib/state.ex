defmodule State do
  require City
  require Country

  defstruct current_country_name: "", country_list: []

  def set_cname(state = %State{}, cname), do: %State{ state | current_country_name: cname }
  
  def country_list(state = %State{}), do: state.country_list
  
  # at index 0 (== first) which should match state.current_country_name
  def country(state = %State{}) do
    country = List.first state.country_list
    if Country.country_name(country) == state.current_country_name do
      { :ok, country }
    else
      { :error }
    end

  end

  def add_country(state = %State{}, country) do
    %State{ state |  country_list: [country | state.country_list] }
  end

  # replacement will always be at index 0 (given the csv file structure)
  def update_country_city_list(state = %State{}, updated_country) do
    %State{ state | country_list: List.replace_at(state.country_list, 0, updated_country) }
  end
end
