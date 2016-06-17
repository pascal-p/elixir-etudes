defmodule Weather.Server do
  use GenServer
  require Logger
  
  @name       __MODULE__
  @url        "http://w1.weather.gov/xml/current_obs/"  
  @user_agent [ {"User-agent", "Elixir client"} ]
  @keep       10    # keep at most 10 items in the state

  defmodule State, do: defstruct list: [], stash_pid: nil
    
  ### GenServer API

  @doc """
  GenServer.init/1 callback
  """
  def init(stash_pid) do
    init_list = Weather.StashWorker.get_list stash_pid
    HTTPoison.start
    { :ok, %State{list: init_list, stash_pid: stash_pid} }   
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
    IO.puts "Recently viewed: #{inspect state.list}"
    {:noreply, state}
  end
  
  def handle_call(request, _from, state) do
    {reply, n_state} = get_weather_info(request, state)
    {:reply, reply, n_state}
  end

  def terminate(_reason, state) do
    Weather.StashWorker.save_list state.stash_pid, state.list
  end

  ### Client API

  @doc """
  Start our queue and link it. This is a helper method

  """

  def start_link(stash_pid) do
    Logger.info "Starting #{@name}"
    GenServer.start_link(@name, stash_pid, [{:name, {:global, @name}}])
  end

  def report(code), do: GenServer.call {:global, @name}, code

  def recent(), do: GenServer.cast {:global, @name}, :recent
  
  ### Helper functions
  
  defp get_weather_info(req, state) do
    if Regex.match?(~r/[A-Z]{4}/, req) do
    #if Regex.match?(~r/[A-Z]{4}/, "#{req}") do
      f_url = @url <> String.upcase(req) <> ".xml"
      Logger.info "Trying: #{f_url} // state: #{inspect state}"
      #
      {status, resp} = HTTPoison.get(f_url, @user_agent)
      Logger.info "Got #{inspect status}"
      [reply, n_state] =
        case {status, resp} do
          {:ok, %HTTPoison.Response{status_code: 200, body: xml_body}} ->
            answer =  (for tag <- [:location, :observation_time_rfc822,
                                   :weather, :temperature_string], do:
                           get_content(tag, xml_body))
            { n_list, _ } = Enum.split(state.list, @keep - 1)
            [{ :ok, answer }, %State{state | list: [req | n_list]}]
          
          {:ok, %HTTPoison.Response{status_code: 404}} ->            
            [{ :error,  :not_found }, state]
          
          {:error, %HTTPoison.Error{reason: reason}} ->
            [{ status, reason }, state]
          
            _ ->
            exit(:odd)  # something odd happened !
        end
       Logger.info "Got #{inspect reply} // new state #{inspect n_state}"
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


# iex -S mix
# Erlang/OTP 18 [erts-7.3.1] [source] [64-bit] [smp:4:4] [async-threads:10] [hipe] [kernel-poll:false]
#
# Compiled lib/weather/server.ex
#
# 23:00:43.278 [info]  Starting App Elixir.OtpWeather
#
# 23:00:43.278 [info]  Starting main supervisor Elixir.Weather.MainSupervisor
#
# 23:00:43.278 [info]  Starting Elixir.Weather.StashWorker 
#
# 23:00:43.279 [info]  Starting sub supervisor
#
# 23:00:43.279 [info]  sub supervisor in charge of Sequence.Server
#
# 23:00:43.279 [info]  Starting Elixir.Weather.Server
# Interactive Elixir (1.2.5) - press Ctrl+C to exit (type h() ENTER for help)
# iex(1)> Weather.Server.report("KSJC")
#
# 23:00:47.706 [info]  Trying: http://w1.weather.gov/xml/current_obs/KSJC.xml // state: %Weather.Server.State{list: []}
#
# 23:00:47.871 [info]  Got :ok
#
# 23:00:47.875 [info]  Got {:ok, [location: "San Jose, San Jose International Airport, CA", observation_time_rfc822: "Fri, 17 Jun 2016 02:53:00 -0700", weather: "Fair", temperature_string: "60.0 F (15.6 C)"]} // new state %Weather.Server.State{list: ["KSJC"]}
# {:ok,
#  [location: "San Jose, San Jose International Airport, CA",
#   observation_time_rfc822: "Fri, 17 Jun 2016 02:53:00 -0700", weather: "Fair",
#   temperature_string: "60.0 F (15.6 C)"]}
# iex(2)>


