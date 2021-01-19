defmodule ResilientTaskTest do
  use ExUnit.Case, async: true
  doctest ResilientTask

  setup do
    start_supervised!(ResilientTask)

    :ok
  end

  describe "start" do
    test "when the task returns an :ok, terminate the task" do
      fun = fn -> {:ok, nil} end

      {:ok, pid} = ResilientTask.start(fun)

      :timer.sleep(100)

      refute Process.alive?(pid)
    end

    test "when the task returns an {:ok, nil}, terminate the task" do
      fun = fn -> {:ok, nil} end

      {:ok, pid} = ResilientTask.start(fun)

      :timer.sleep(100)

      refute Process.alive?(pid)
    end

    test "when the task does not return a success response, do not terminate it, and retry in the next time with backoff" do
      fun = fn -> {:error, nil} end

      {:ok, pid} = ResilientTask.start(fun)

      :timer.sleep(100)

      assert Process.alive?(pid)

      Process.exit(pid, :shutdown)
    end

    test "call on_failure when the function fails" do
      parent = self()
      fun = fn -> {:error, nil} end
      on_failure = fn pid, iteration, result -> send(parent, {pid, iteration, result}) end

      {:ok, pid} = ResilientTask.start(fun, on_failure: on_failure)

      assert_receive {^pid, 1, {:error, nil}}

      %{backoff: backoff} = :sys.get_state(pid)
      {next_retry_in_ms, _} = ResilientTask.Backoff.backoff(backoff)

      refute_receive {^pid, 2, {:error, nil}}
      :timer.sleep(next_retry_in_ms)
      assert_receive {^pid, 2, {:error, nil}}
      assert Process.alive?(pid)

      Process.exit(pid, :shutdown)
    end
  end

  describe "close/1" do
    test "close the task" do
      fun = fn -> :timer.sleep(3_000) end
      {:ok, pid} = ResilientTask.start(fun)

      assert :ok = ResilientTask.close(pid)
      refute Process.alive?(pid)
    end

    test "close a non existing task, returns an {:error, :not_found} tuple" do
      assert {:error, :not_found} = ResilientTask.close(self())
    end
  end
end
