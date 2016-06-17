defmodule Weather.StashWorker do
  use GenServer
  require Logger

  @vsn "1"
  @name __MODULE__

  defmodule State, do: defstruct list: []

  ### External API
  def start_link(curr_num) do
    Logger.info "Starting #{@name} "
    {:ok, _pid} = GenServer.start_link(@name, curr_num)
  end

  def save_list(pid, list), do: GenServer.cast pid, {:save_list, list}

  def get_list(pid), do: GenServer.call pid, :get_list

  ### GenServer Impl
  def init(list) do
    { :ok, %State{list: list} }
  end

  def handle_cast({:save_list, list}, state)  do
    {:noreply, %State{state | list: list}}
  end

  def handle_call(:get_list, _from, state) do
    # tuple: {:reply, response, state}
    {:reply, state.list, state}
  end

end
