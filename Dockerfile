FROM ruby:3.1.3-slim-bullseye

RUN apt-get update -y \
    && apt-get install -y build-essential m4 vim curl zstd \
       autoconf automake cmake libtool \
       libzstd-dev

RUN gem update --system && gem install bundler

WORKDIR /app

RUN curl -sLfo silesia.tar.zstd https://xb1-p.us-east-1.linodeobjects.com/silesia.tar.zstd && \
    zstd -d silesia.tar.zstd && tar xf silesia.tar && \
    rm -Rf silesia.tar.zstd silesia.tar

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

RUN bundle config set --local deployment true \
    && bundle install

COPY . /app

CMD ["cd /app && bundle exec ruby main.rb $FILE"]
ENTRYPOINT ["/bin/bash", "-c"]
