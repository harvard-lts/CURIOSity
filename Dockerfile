ARG RUBY_VERSION=2.7.2
FROM ruby:$RUBY_VERSION-alpine as spotlight

ENV RAILS_SERVE_STATIC_FILES="1"
ENV RAILS_LOG_TO_STDOUT="1"

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
  zip

RUN gem update bundler

RUN mkdir -p /app/spotlight
WORKDIR /app/spotlight

COPY --chown=1001:101 $APP_PATH/Gemfile* /app/spotlight/
RUN bundle config set force_ruby_platform true
RUN bundle check || bundle install --jobs "$(nproc)"

COPY --chown=1001:101 $APP_PATH /app/spotlight

RUN RAILS_ENV=production SECRET_KEY_BASE=`bin/rake secret` DB_ADAPTER=nulldb DATABASE_URL='postgresql://fake' bundle exec rake assets:precompile

CMD ["bundle", "exec", "puma", "-b", "tcp://0.0.0.0:3000"]
