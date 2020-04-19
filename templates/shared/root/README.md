*Replace all examples and italic texts with project specific explanations**

# _Project Title_

_One Paragraph of project description goes here. Describe briefly the project and its goal to give a rough understanding about it. Please mention the main programming language (PHP, Elixir, Ruby). This should also include a rough overview of the context (i.e. dependent projects and production environment)_

## Quickstart – Docker

You can use Docker Compose to start the project.

### Configuration/Setup

None

### Database migration

Run database migrations from the `web` container with

    docker-compose exec web sh
    mix ecto.migrate

### Start

Start the databases and the Phoenix server with: 

    docker-compose up

## Start – manual way

**You can skip this part if you are using Docker.**

The following steps will explain the setup to start the app.

### Prerequisites

_What things you need to install the software and how to install them. Add the version to the dependency instead of only the name (Python 3.6 instead of Python). Also mention possible running software like databases or cache server._

- [Erlang/OTP @ 22](https://www.erlang.org/)
    - Included in most distributions package manager.
- [Elixir @ 1.9](https://elixir-lang.org/)
    - I incline to use asdf (https://asdf-vm.com/#/)
- [Hex (Elixir package manager)](https://hex.pm/)
    - `mix local.hex`
- [Phoenix @ 1.4.12](https://hexdocs.pm/phoenix/installation.html)
    - `mix archive.install hex phx_new 1.4.9`
- [PostgreSQL @ 11.4](https://www.postgresql.org/)
    - Included in most distributions package manager.
- [NodeJs @ 10.X](https://nodejs.org/en/)
    - Included in most distributions package manager.

### Installing

Get the elixir/mix dependencies:

    mix deps.get
    
Get the npm dependencies:

    cd assets
    npm i

Also run necessary database migrations.

### Configuration

Follow the steps in the section for the docker configuration.

Adapt the database URLs to the database in the `dev|test.secret.exs` to your database. 

### Start

    mix phx.server

You can run the phoenix server in an interactive session with:

    iex -S mix phx.server

## Access application

Open the URL in your browser:

    
    http://localhost:8080
    

## Environment variables

_List necessary environment variables and their meaning. If there is a `.env` file, give a hint._

  - DATABASE_URL [String] - Connection string to your database (postgres://user:password@host/database)

## Building and Deployment

There are two Dockerfiles. `Dockerfile` is for development and testing. The `Dockerfile_prod`is for building a 
production version of your app. The latter uses [Elixir releases](https://hexdocs.pm/mix/Mix.Tasks.Release.html) /
[Phoenix releases](https://hexdocs.pm/phoenix/releases.html).

## Automatic tests

_Explain how the tests can be started and if they need additional configuration based on the installation process_

Run the Elixir backend tests (do not forget to set the `DATABASE_URL`):

    mix test    

## Major dependencies

_Mention and link the main dependencies of the project. These are frameworks, depedency manager, project management tools and bigger libraries. No need to list every little dependency._

- [Elixir](https://hexdocs.pm/elixir/Kernel.html) - The function language for the backend.
- [Phoenix](https://hexdocs.pm/phoenix/overview.html) - The web framework of the project.
- [Ecto](https://hexdocs.pm/ecto/Ecto.html) - The database layer of Phoenix. 

_Add the documentation to your framework_

### Hint 

The hexdocs websites contains useful shortcuts: 

  - Press `g` to switch to another dependency and its documentation. 
  - Press `s` to switch to the search bar and start typing what you are looking for.
  - Press `n` to toggle dark mode.

## Useful hints

_List and describe useful information about the code in sub headings. For example, a central hack and why it is used. This list is intended to be short._
