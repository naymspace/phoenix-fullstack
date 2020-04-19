FROM elixir:1.10.2-alpine

RUN apk update && apk upgrade && \
    apk add nodejs npm inotify-tools

RUN mix local.hex --force && \
    mix archive.install --force hex phx_new 1.4.16

RUN mkdir -p /app/assets
WORKDIR /app

COPY assets/package.json assets/package-lock.json /app/assets/
ENV NODE_ENV dev
RUN npm install --prefix assets

COPY mix.exs mix.lock /app/
RUN mix deps.get --force && \
    mix local.rebar --force && \
    mix deps.compile

COPY . /app/

EXPOSE 4000
CMD mix phx.server
