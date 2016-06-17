defmodule Weather.SubSupervisor do
  use Supervisor
  require Logger

  @name __MODULE__

  def start_link(stash_pid) do
    Logger.info "Starting sub supervisor"
    {:ok, _pid} =  Supervisor.start_link(@name, stash_pid) # will call init(...) below
  end

  def init(stash_pid) do
    Logger.info "sub supervisor in charge of Sequence.Server"
    child_procs = [ worker(Weather.Server, [stash_pid]) ]
    supervise child_procs, strategy: :one_for_one
  end

end
