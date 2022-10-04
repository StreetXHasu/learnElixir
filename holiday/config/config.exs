import Config
config :holiday, ecto_repos: [Holiday.Repo]

config :holiday, Holiday.Repo,
  database: "holiday_repo",
  username: "postgres",
  password: "",
  hostname: "localhost"
