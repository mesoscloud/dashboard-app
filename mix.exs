defmodule Dashboard.Mixfile do
  use Mix.Project

  def project do
    [app: :dashboard,
     version: "1.0.0",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    [applications: [:logger, :cowboy, :plug, :riemann],
     mod: {Dashboard, []}]
  end

  defp deps do
    [{:cowboy, "~> 1.0.0"},
     {:plug, "~> 1.0"},
     {:poison, "~> 2.0"},
     {:riemann, " ~> 0.0.15"}]
  end
end
