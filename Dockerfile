FROM elixir:1.11-alpine
WORKDIR /app

# We need GIT to resolve mix dependencies
# Bash is nice to enter the container
RUN apk update && apk upgrade && \
  apk add git bash

RUN mix local.hex --force && \
  mix archive.install --force hex phx_new 1.5.7

COPY mix.exs ./
RUN mix deps.get --force && \
  mix local.rebar --force && \
  mix deps.compile


COPY . .

RUN mix compile
RUN export version=$(mix version); \
    mix archive.build && \
    mix archive.install phoenix_full_stack-$version.ez --force

WORKDIR /project
CMD bash
