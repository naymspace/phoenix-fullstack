FROM elixir:1.11-alpine AS build

# install build dependencies
RUN apk add --no-cache git

# prepare build dir
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ENV MIX_ENV=prod

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
RUN mix do deps.get, deps.compile

COPY priv priv

# compile and build release
COPY lib lib
# uncomment COPY if rel/ exists
RUN mix do compile, release

# prepare release image
FROM alpine:3.9 AS app
RUN apk add --no-cache openssl ncurses-libs bash lsof file

WORKDIR /app

RUN chown nobody:nobody /app

USER nobody:nobody

COPY --from=build --chown=nobody:nobody /app/_build/prod/rel/:<%= app_name %> ./

ENV HOME=/app

CMD ["bin/:<%= app_name %>", "start"]
