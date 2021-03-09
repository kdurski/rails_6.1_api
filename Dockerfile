FROM ruby:3.0.0

RUN apt-get update && apt-get install --no-install-recommends --yes default-libmysqlclient-dev=1.0.5 && rm -rf /var/lib/apt/lists/*

ENV PROJECT_DIR=$HOME/app
ENV RAILS_ENV=production
ENV RAILS_LOG_TO_STDOUT=true

RUN mkdir -p $PROJECT_DIR && mkdir -p "$PROJECT_DIR/tmp/sockets" && mkdir -p "$PROJECT_DIR/tmp/pids" && chmod 744 $PROJECT_DIR

WORKDIR $PROJECT_DIR

COPY Gemfile Gemfile.lock ./
RUN bundle install -j "$(nproc)" --without development test --no-cache \
  && rm -fr "$HOME/.bundle/cache" \
  && rm -fr "$HOME/.bundler/cache"

# Copy application code into container file-system
COPY . ./

# Expose app server port
EXPOSE 3000

CMD ["puma"]