FROM elixir:1.2.5
MAINTAINER Peter Ericson <pdericson@gmail.com>

# https://github.com/Yelp/dumb-init
RUN curl -fLsS -o /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.0.2/dumb-init_1.0.2_amd64 && \
chmod +x /usr/local/bin/dumb-init

WORKDIR /app

RUN mix local.hex --force
COPY mix.exs /app/
RUN mix hex.info && \
mix deps.get && \
mix deps.compile

COPY . /app
RUN mix compile && \
mix test

ENTRYPOINT ["/usr/local/bin/dumb-init"]
CMD ["mix", "run", "--no-halt"]
EXPOSE 4000
