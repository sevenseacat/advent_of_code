import Config

config :elixir, :dbg_callback, {Macro, :dbg, []}

# Allow non-UTC timezone checks - AOC is in UTC-5
config :elixir, :time_zone_database, Tz.TimeZoneDatabase
