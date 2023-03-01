FROM ruby:3.1.2-slim-bullseye

RUN apt-get update -y \
    && apt-get install -y build-essential m4 vim \
       autoconf automake cmake libtool \
       libzstd-dev

RUN gem update --system && gem install bundler

WORKDIR /app

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

RUN bundle config set --local deployment true \
    && bundle install

COPY . /app

CMD ["cd /app && bundle exec ruby main.rb"]
ENTRYPOINT ["/bin/bash", "-c"]

