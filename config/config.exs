use Mix.Config

config :riemann, :address,
  host: System.get_env("HOST"),
  port: 5555
