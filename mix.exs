defmodule ResilientTask.MixProject do
  use Mix.Project

  @source_url "https://github.com/elielhaouzi/resilient_task"
  @version "0.1.0"

  def project do
    [
      app: :resilient_task,
      version: @version,
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      package: package(),
      description: description(),
      deps: deps(),
      docs: docs()
    ]
  end

  defp description() do
    "Persistent blocking job queue"
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    []
  end

  defp package() do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => @source_url}
    ]
  end

  defp docs do
    [
      main: "readme",
      source_url: @source_url,
      extras: [
        "README.md"
      ]
    ]
  end
end
