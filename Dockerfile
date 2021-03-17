FROM us.gcr.io/autogrid-dev/core/ag-ruby:3.0.0

ENV PROJECT_DIR=$HOME/fa
ENV RAILS_ENV=production
ENV RAILS_LOG_TO_STDOUT=true

RUN mkdir -p $PROJECT_DIR && chmod 744 $PROJECT_DIR

WORKDIR $PROJECT_DIR

COPY --chown=autogrid:autogrid Gemfile Gemfile.lock ./
RUN bundle install -j "$(nproc)" --without development test --no-cache \
    && rm -fr "$HOME/.bundle/cache" \
    && rm -fr "$HOME/.bundler/cache"

# Copy application code into container file-system
COPY --chown=autogrid:autogrid . ./

# Expose app server port
EXPOSE 3000

CMD ["puma"]

