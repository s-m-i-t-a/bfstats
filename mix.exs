defmodule Bfstats.Mixfile do
  use Mix.Project

  def project do
    [app: :bfstats,
     version: "0.1.0",
     elixir: "~> 1.4",
     escript: escript_config(),
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    # [extra_applications: [:logger]]
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:csv, "~> 2.0.0"},
      {:timex, "~> 3.1"},
      {:result, "~> 1.1"},
      {:dogma, "~> 0.1", only: :dev},
      {:credo, "~> 0.8", only: [:dev, :test], runtime: false},
    ]
  end

  defp escript_config do
    [main_module: Bfstats.CLI]
  end
end
