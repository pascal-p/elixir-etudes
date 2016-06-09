# %City { name, population, latitude, longitude }

defmodule City do

  require Valid
  require Inspect
  require Utils
  
  defstruct name: "", population: 0, latitude: 0.0, longitude: 0.0

  def init(name, population, latitude, longitude) do
    %City{ %City{} |
           name: name, population: population, latitude: latitude, longitude: longitude }
  end

  def population(city = %City{}), do: city.population

  defimpl Valid, for: City do
    def valid?(%City{name: _, population: pop, latitude: lat, longitude: long}) do
      valid_population?(pop) && valid_lat?(lat) && valid_long?(long)
    end

    defp valid_population?(pop) do
      pop > 0
    end

    defp valid_lat?(lat) do
      lat >= -90.0 && lat <= 90.0
    end

    defp valid_long?(long) do
      long >= -180.0 && long <= 180.0
    end
  end
  
  defimpl Inspect, for: City do
    def inspect(%City{name: name, population: pop, latitude: lat, longitude: long}, _opts) do
      lat  = Utils.round(lat)
      long = Utils.round(long)
      "#{name} (#{Utils.num_to_str(pop)}) #{lat_to_str(lat)} #{long_to_str(long)}"      
    end
    
    defp lat_to_str(lat) do
      case lat do
        lat when lat > 0.0 -> "#{lat}°N"
        lat when lat < 0.0 -> "#{lat * -1.0}°S"
        0.0 -> "0.0"
      end
    end
    
    defp long_to_str(long) do
      case long do
        long when long > 0.0 -> "#{long}°E"
        long when long < 0.0 ->  "#{long * -1.0}°W"
        0.0 -> "0.0"
      end
    end
    
  end

end
