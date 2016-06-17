defmodule Weather.MainSupervisor do
  use Supervisor
  require Logger

  @name __MODULE__

  def start_link(init_list \\ []) do
    Logger.info "Starting main supervisor #{@name}"
    result = {:ok, main_sup_pid} = Supervisor.start_link(@name, init_list) # will call init(...) below
    start_workers(main_sup_pid, init_list)
    result
  end

  def init(_) do
    supervise [], strategy: :one_for_one
    # no children yet, hence []
  end

  defp start_workers(main_sup_pid, init_list) do
    # (1) start the stash worker (process)
    {:ok, stash_pid} = Supervisor.start_child(main_sup_pid,
                                              worker(Weather.StashWorker, [init_list]))
    # (2) start sub-supervisor (for Sequence server)
    Supervisor.start_child(main_sup_pid,
                           supervisor(Weather.SubSupervisor, [stash_pid]))
  end
end
