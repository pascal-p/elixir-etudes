defmodule Geography do

  require State     # internal state
  require Country   # which requires the City

  @moduledoc """
  Using files and structures.
  from *Études for Elixir*, O'Reilly Media, Inc., 2014.
  """

  @vsn 0.1

  @doc """
  Open a file whose name is given in the first argument.
  The file contains country name and primary language,
  followed by (for each country) lines giving the name
  of a city, its population, latitude, and longitude.

  Construct a Country structure for each country containing
  the cities in that country.
  """
  @spec make_geo_list(String.t) :: [Country]

  
  def make_geo_list(file \\ "./resources/geography.csv") do
    fh = f_open(file)
    geo_list = init_geo_list_from(fh) # return a geo_list or error
    if geo_list == :error do
      { :error }
    else
      {:ok, geo_list }
    end
  end

  @doc """
  Find the total population of all cities in the list
  that are in countries with a given primary language.
  """
  @spec total_population([Country], String.t) :: integer
  
  def total_population(geo_list, country_name) do
    f_country = Enum.find(geo_list, fn(country) -> country.name == country_name end)
    case f_country do
      nil ->
        :error
      _ ->
        f_country.city_population
    end
  end

  defp f_open(file) do
    {:ok, fh} = File.open(file, [:read, :utf8])
    fh
  end

  defp init_geo_list_from(fh) do
    f_read_by_lines(%State{}, fh)
  end

  defp f_read_by_lines(state, fh) do
    line = IO.read(fh, :line)
    case line do
      :eof ->
        File.close(fh)
        cond do 
          state == :error -> :error
          true ->
            state.country_list
        end
      _ ->
        new_state = update(state, line)
        f_read_by_lines(new_state, fh)
    end
  end

  defp update(state, line) do
    data_list = String.strip(line) |> String.split(",")
    # retunr new state or :error
    case Kernel.length(data_list) do
      2 -> add_new_country(state, data_list)
      4 -> add_new_city(state, data_list)
      _ -> :error
    end
  end

  defp add_new_country(state, [c_name, c_language]) do
    new_state   = State.set_cname(state, c_name)
    new_country = Country.init(c_name, c_language)
    # return updated state: 
    State.add_country(new_state, new_country)
  end

  defp add_new_city(state, [city_name, population, latitude, longitude]) do
    new_city = City.init(city_name, conv_2_integer(population),
                         conv_2_float(latitude),
                         conv_2_float(longitude))
    if Valid.valid?(new_city) do
      {:ok, country}  = State.country(state)
      updated_country = Country.add_city(country, new_city)
      # return updated state:
      State.update_country_city_list(state, updated_country)
    else
      :error
    end
  end

  defp conv_2_integer(entry) do
    { conversion, _ } = Integer.parse(entry, 10)
    conversion
  end

  defp conv_2_float(entry) do
    { conversion,   _ } = Float.parse(entry)
    conversion
  end

end
