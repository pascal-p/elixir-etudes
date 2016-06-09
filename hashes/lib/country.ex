# %Country { name, language, cities: [ %City ] }

defmodule Country do
  
  require City
  require Inspect
  
  defstruct name: "", language: "", city_population: 0, cities: []

  def init(name, language) do
    %Country{ %Country{} | name: name, language: language }
  end
  
  def country_name(country = %Country{}), do: country.name
  
  def add_city(country = %Country{}, city = %City{}) do
    %Country{ country | cities: [city | country.cities],
              city_population: country.city_population + city.population }
  end
  
  defimpl Inspect, for: Country do
    def inspect(%Country{name: name, language: lang, city_population: pop, cities: cities}, _opts) do
      "#{name} (#{Utils.num_to_str(pop)}) #{lang} #{inspect cities}"
    end
  end
end
