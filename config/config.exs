import Config

# Allow non-UTC timezone checks - AOC is in UTC-5
config :elixir, :time_zone_database, Tz.TimeZoneDatabase

config :nx, default_backend: EXLA.Backend
