# AG Ruby Dockerfile that can be later used by jenkins
# https://github.com/auto-grid/devops/blob/master/kubernetes/core/ruby/2.6.3/Dockerfile

##################
## BUILD RUBY
##################

#FROM us.gcr.io/autogrid-dev/core/ag-ubuntu-18.04:latest

## "ag-ubuntu"
# reproduce the ag-ubuntu-18.04 image untill we have pipeline ready
FROM ubuntu:18.04
COPY ubuntu-hardening.sh /root/ubuntu-hardening.sh
RUN apt-get update -y --no-install-recommends && \
apt-get install -y --no-install-recommends gosu && \
rm -rf /var/lib/apt/lists/* && \
useradd -d /opt/autogrid -ms /bin/bash -u 1000 autogrid && \
sed -i -r 's/^autogrid:!:/autogrid:x:/' /etc/shadow && \
/bin/sh /root/ubuntu-hardening.sh
## end of: "ag-ubuntu"

RUN mkdir -p /opt/autogrid /home/autogrid && chown -R autogrid:autogrid /opt/autogrid /home/autogrid

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    procps \
    libssl-dev \
    bison \
    autoconf \
    build-essential \
    git \
    libreadline-dev \
    ca-certificates \
    libmysqlclient-dev \
    && rm -rf /var/lib/apt/lists/*

# switch to ag user
USER autogrid
ENV HOME "/home/autogrid"

ENV RUBY_MAJOR 3.0
ENV RUBY_VERSION 3.0.0

## Clone rbenv and ruby-build  repo's
# ruby-build is a command-line utility that makes it easy to install virtually any version of Ruby, from source.
# It is available as a plugin for rbenv that provides the rbenv install command
RUN git clone https://github.com/rbenv/rbenv.git $HOME/.rbenv
WORKDIR $HOME/.rbenv
RUN src/configure && make -C src

ENV PATH $HOME/.rbenv/bin:$PATH

# Install Ruby using rbenv
RUN mkdir -p $HOME/.rbenv/plugins/ruby-build \
  && git clone https://github.com/rbenv/ruby-build.git $HOME/.rbenv/plugins/ruby-build

RUN rbenv install $RUBY_VERSION \
  && rbenv global $RUBY_VERSION \
  && rbenv rehash

RUN echo 'gem: --no-rdoc --no-ri' >> $HOME/.gemrc

## Gem installation steps
RUN mkdir -p $HOME/.bundler
ENV GEM_HOME $HOME/.bundler

ENV PATH $HOME/.rbenv/versions/$RUBY_VERSION/bin:$GEM_HOME/bin:$PATH

# Install bundler
RUN gem install bundler \
    && gem install rubygems-bundler \
    && bundle config --global path "$GEM_HOME" \
    && bundle config --global bin "$GEM_HOME/bin"

# don't create ".bundle" in all our apps
ENV BUNDLE_APP_CONFIG $GEM_HOME

##################
## APP SPECIFIC CODE
##################

# Create the main working directory and some other directories required by the app.
RUN mkdir -p /opt/autogrid/fa \
    && mkdir -p /opt/autogrid/fa/tmp/sockets \
    && mkdir -p /opt/autogrid/fa/tmp/pids \
    && chown -R autogrid:autogrid /opt/autogrid/fa \
    && chmod 744 /opt/autogrid/fa

ENV RAILS_ENV=production
ENV RAILS_LOG_TO_STDOUT=true
WORKDIR /opt/autogrid/fa

COPY --chown=autogrid:autogrid Gemfile Gemfile.lock ./
RUN bundle install -j "$(nproc)" --without development test --no-cache \
    && rm -fr /home/autogrid/.bundle/cache \
    && rm -fr /home/autogrid/.bundler/cache

# Copy application code into container file-system
COPY --chown=autogrid:autogrid . ./

# Expose app server port
EXPOSE 3000

CMD ["puma"]

