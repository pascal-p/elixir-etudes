defmodule Weather do
  use GenServer
  require Logger
  
  @name       __MODULE__
  @url        "http://w1.weather.gov/xml/current_obs/"  
  @user_agent [ {"User-agent", "Elixir client"} ]
  @keep       10    # keep at most 10 items in the state
  
  ### GenServer API

  @doc """
  GenServer.init/1 callback
  """
  def init(state) do
    HTTPoison.start
    {:ok, state}
  end


  @doc "Connect to another node"
  @spec connect(atom) :: atom
  
  def connect(onode) do
    case :net_adm.ping(onode) do
      :pong ->
        Logger.info "Connected to server."
        :ok
      :pang ->
        Logger.error "Could not connect."
        :error
    end
  end
  
  ## Handling synchronous calls

  @doc """
  GenServer.handle_call/3 callback
  """

  # need to be before handle_call(request, ...)
  def handle_cast(:recent, state) do
    IO.puts "Recently viewed: #{inspect state}"
    {:noreply, state}
  end
  
  def handle_call(request, _from, state) do
    {reply, n_state} = get_weather_info(request, state)
    {:reply, reply, n_state}
  end


  ### Client API

  @doc """
  Start our queue and link it. This is a helper method

  """

  def start_link(state \\ []) do
    GenServer.start_link(@name, state, [{:name, {:global, @name}}])
  end

  def report(code), do: GenServer.call {:global, @name}, code

  def recent(), do: GenServer.cast {:global, @name}, :recent
  
  ### Helper functions
  
  defp get_weather_info(req, state) do
    if Regex.match?(~r/[A-Z]{4}/, "#{req}") do
      f_url = @url <> String.upcase(req) <> ".xml"
      Logger.info "Trying: #{f_url}"
      #
      {status, resp} = HTTPoison.get(f_url, @user_agent)
      [reply, n_state] =
        case {status, resp} do
          {:ok, %HTTPoison.Response{status_code: 200, body: xml_body}} ->
            answer =  (for tag <- [:location, :observation_time_rfc822,
                                   :weather, :temperature_string], do:
                           get_content(tag, xml_body))
            { n_state, _ } = Enum.split(state, @keep - 1)
            [{ :ok, answer }, [req | n_state]]
          
          {:ok, %HTTPoison.Response{status_code: 404}} ->            
            [{ :error,  :not_found }, state]
          
          {:error, %HTTPoison.Error{reason: reason}} ->
            [{ status, reason }, state]
          
            _ ->
            exit(:odd)  # something odd happened !
        end
      {reply, n_state}
    else
      {:error, :not_a_4_letter_code}
    end    
  end

  ## Parsing the data
  defp get_content(tag_name, xml) do
    {_, pattern} = Regex.compile("<#{tag_name}>([^<]+)</#{tag_name}>")
    #
    result = Regex.run(pattern, xml)
    #
    case result do
      [_all, match] -> {tag_name, match}
      nil -> {tag_name, nil}
    end
  end
  
end


# iex(1)> Weather.start_link
# {:ok, #PID<0.180.0>}
# iex(20> Weather.report("KSJC")
# 10:40:46.285 [info]  Trying: http://w1.weather.gov/xml/current_obs/KSJC.xml
# {:ok,
#  [location: "San Jose, San Jose International Airport, CA",
#   observation_time_rfc822: "Thu, 16 Jun 2016 14:53:00 -0700",
#   weather: "Partly Cloudy", temperature_string: "75.0 F (23.9 C)"]}
# iex(3)> 
#
#
#
# iex(2)> GenServer.call(Weather, "KSJC")
# >> Trying: http://w1.weather.gov/xml/current_obs/KSJC.xmlKSJC.xml
#  >> Got an answer...
# {:ok,
#  %HTTPoison.Response{body:  ...
