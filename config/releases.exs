import Config

config :name_game, NameGameWeb.Endpoint,
  server: true,
  http: [port: {:system, "PORT"}],
  url: [host: "namegame.stevegrossi.com", port: 443],
  cache_static_manifest: "priv/static/cache_manifest.json",
  check_origin: ["//namegame.stevegrossi.com"],
  force_ssl: [rewrite_on: [:x_forwarded_proto]]
