defmodule ResilientTask do
  @moduledoc """
  Documentation for `ResilientTask`.
  """
  use DynamicSupervisor

  def start_link(init_arg) do
    DynamicSupervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  def init(_init_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start(fun, opts \\ []) when is_function(fun, 0) do
    DynamicSupervisor.start_child(
      __MODULE__,
      {ResilientTask.Worker, Keyword.merge([fun: fun], opts)}
    )
  end

  def close(pid) when is_pid(pid) do
    DynamicSupervisor.terminate_child(__MODULE__, pid)
  end

  def close_all(pid) when is_pid(pid) do
    DynamicSupervisor.which_children(__MODULE__)
    |> Enum.each(fn
      {:undefined, :restarting, :worker, _} ->
        nil

      {:undefined, child_pid, :worker, _} when is_pid(child_pid) ->
        close(child_pid)
    end)
  end
end
