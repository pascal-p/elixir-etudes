defmodule OtpWeather do
  use Application
  require Logger


  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    Logger.info "Starting App #{__MODULE__}"
    {:ok, _pid} = Weather.MainSupervisor.start_link() # Application.get_env(:sequence, :init_number)
  end
end
