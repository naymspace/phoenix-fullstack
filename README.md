# PhoenixTemplate

A Mix task to create full stack web apps based on Phoenix. 

## Content

The Mix task will create a Phoenix project and adapt the configuration to our needs. It will also install
a frontend.

The content in detail is the following:

+ Phoenix default app with Ecto and Postgres
+ Docker files for development and production (uses Elixir releases)
+ Docker-Compose for local development
+ Default README.md
+ Docker and Git Ignore 

The supported frontends are:

+ Vue 2 with
    + Vuex
    + Router
    + Typescript
+ React
    + Redux
    + Typescript
+ Elm (**NOT YET IMPLEMENTED**)

## Requirements

- [Erlang/OTP @ 22](https://www.erlang.org/)
    - Included in most distributions package manager.
- [Elixir @ 1.9](https://elixir-lang.org/)
    - I incline to use asdf (https://asdf-vm.com/#/)
- [Hex (Elixir package manager)](https://hex.pm/)
    - `mix local.hex`
- [Phoenix @ 1.4.12](https://hexdocs.pm/phoenix/installation.html)
    - `mix archive.install hex phx_new 1.4.12`

## Installation

### Compile and install

Download this repository.

Create a Mix archive:

`mix archive.build`

This should output the following text (version can vary):
> Generated archive "phoenix_template-0.1.0.ez" with MIX_ENV=dev 

Install the Mix archive 

`mix archive.install phoenix_template-0.1.0.ez`

This should output the following questions (version can vary):

> Are you sure you want to install "phoenix_template-0.1.0.ez"? [Yn] y  
> creating ~/.mix/archives/phoenix_template-0.1.0

## Usage

Create a new project (will invoke the Phoenix creation at first):

    mix full_stack.new PATH [OPTIONS]
      
The **path** must be Phoenix compatible. 

The options are:

    `--frontend` - Required. The frontend technology to use. One of:
      * `vue` - Vue 2 with Vuex, Router and Typescript. Compatible with the Vue-Cli
      * `react` - React with Redux, Router and Typescript.
      * `elm` - **NOT YET IMPLEMENTED**
