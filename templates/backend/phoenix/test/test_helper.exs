Faker.start()
ExUnit.start(exclude: [:skip])
Ecto.Adapters.SQL.Sandbox.mode(<%= app_module %>.Repo, :manual)
