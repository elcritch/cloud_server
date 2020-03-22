defmodule CloudServer.MixProject do
  use Mix.Project

  @app :cloud_server
  @version "0.1.0"
  @all_targets [:x86_64, :x86_64_gnu]
  @target System.get_env("MIX_TARGET") || "host"

  def project do
    [
      app: @app,
      version: @version,
      elixir: "~> 1.9",
      archives: [nerves_bootstrap: "~> 1.6"],
      start_permanent: Mix.env() == :prod,
      build_embedded: true,
      # deps_path: "deps/#{@target}",
      # build_path: "_build/#{@target}",
      # lockfile: "mix.lock.#{@target}",
      aliases: [loadconfig: [&bootstrap/1]],
      deps: deps(),
      releases: [{@app, release()}],
      preferred_cli_target: [run: :host, test: :host]
    ]
  end

  # Starting nerves_bootstrap adds the required aliases to Mix.Project.config()
  # Aliases are only added if MIX_TARGET is set.
  def bootstrap(args) do
    Application.start(:nerves_bootstrap)
    Mix.Task.run("loadconfig", args)
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {CloudServer.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # Dependencies for all targets
      {:nerves, "~> 1.5.0", runtime: false},
      {:shoehorn, "~> 0.6"},
      {:ring_logger, "~> 0.6"},
      {:toolshed, "~> 0.2"},

      # Dependencies for all targets except :host
      {:nerves_runtime, "~> 0.6", targets: @all_targets},
      {:nerves_init_gadget, "~> 0.4", targets: @all_targets},
      # {:nerves_firmware_ssh, "~> 0.4", targets: @all_targets},

      # System
      # {:nerves_tier, "~> 0.1.2", github: "elcritch/nerves_tier"},
      {:bulma_widgets_phx_test, "~> 0.1", git: "git@github.com:elcritch/bulma_widgets_phx_test.git"},

      # Dependencies for specific targets
      # {:nerves_system_x86_64, "~> 1.8", runtime: false, targets: :x86_64},
      {:nerves_system_x86_64_gnu, "~> 1.8", github: "elcritch/nerves_system_x86_64", runtime: false, targets: :x86_64_gnu},
    ]
  end

  def release do
    [
      overwrite: true,
      cookie: "#{@app}_cookie",
      include_erts: &Nerves.Release.erts/0,
      steps: [&Nerves.Release.init/1, :assemble],
      strip_beams: Mix.env() == :prod
    ]
  end
end
