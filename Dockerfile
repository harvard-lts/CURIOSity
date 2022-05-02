ARG RUBY_VERSION=2.7.5
FROM ruby:$RUBY_VERSION-alpine as spotlight

ENV RAILS_SERVE_STATIC_FILES="1"
ENV RAILS_LOG_TO_STDOUT="1"
ARG APP_ID_NUMBER=55000
ARG APP_ID_NAME=curiosity
ARG GROUP_ID_NUMBER=55000
ARG GROUP_ID_NAME=curiosity

RUN apk --no-cache upgrade && \
  apk add --no-cache \
  build-base \
  curl \
  git \
  imagemagick \
  less \
  libxml2-dev \
  libxslt-dev \
  nodejs-current \
  postgresql-dev \
  shared-mime-info \
  sqlite-dev \
  tzdata \
  yarn \
  zip && \
  addgroup -S ${GROUP_ID_NAME} -g ${GROUP_ID_NUMBER} && \
  adduser -h /home/${APP_ID_NAME} -s /bin/sh -u ${APP_ID_NUMBER} -S ${APP_ID_NAME} -G ${GROUP_ID_NAME}

RUN gem update bundler

RUN mkdir -p /app/spotlight && \
    mkdir /app/bundle && \
    mkdir /app/spotlight/node_modules && \
    chown -R ${APP_ID_NAME} /app/bundle && \
    chown -R ${APP_ID_NAME} /app/spotlight/node_modules
WORKDIR /app/spotlight

COPY --chown=${APP_ID_NAME} . /app/spotlight
USER ${APP_ID_NAME}

RUN mkdir -p /app/spotlight/tmp && \
    bundle config set force_ruby_platform true && \
    bundle install --jobs "$(nproc)" --path /app/bundle && \
    RAILS_ENV=production SECRET_KEY_BASE=`bin/rake secret` DB_ADAPTER=nulldb DATABASE_URL='postgresql://fake' bundle exec rake assets:precompile

CMD ["bundle", "exec", "puma", "-b", "tcp://0.0.0.0:3000"]