defmodule ResilientTask.Worker do
  @moduledoc false

  use GenServer, restart: :transient
  alias ResilientTask.Backoff
  # Callbacks

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  # Server Callbacks

  def init(opts) do
    Process.send(self(), :work, [])

    fun = Keyword.fetch!(opts, :fun)
    on_failure = Keyword.get(opts, :on_failure)

    state = %{
      fun: fun,
      backoff: Backoff.new(backoff_type: :exp, backoff_min: 1000, backoff_max: 120_000),
      iteration: 0,
      on_failure: on_failure
    }

    {:ok, state}
  end

  def handle_info(:work, %{fun: fun, backoff: backoff, iteration: iteration} = state) do
    exec_fun(fun)
    |> handle_result()
    |> case do
      :ok ->
        {:stop, :normal, state}

      {:error, error} ->
        iteration = iteration + 1
        {next_retry, backoff} = Backoff.backoff(backoff)
        schedule_next_retry(next_retry)

        if state.on_failure do
          state.on_failure.(self(), iteration, error)
        end

        {:noreply, state |> Map.merge(%{backoff: backoff, iteration: iteration})}
    end
  end

  defp schedule_next_retry(time) do
    Process.send_after(self(), :work, time)
  end

  defp exec_fun(fun) do
    fun.()
  end

  defp handle_result({:ok, _}), do: :ok
  defp handle_result(:ok), do: :ok
  defp handle_result(result), do: {:error, result}
end
