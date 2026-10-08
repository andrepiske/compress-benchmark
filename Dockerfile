FROM andrepiske/ruby:4.0.7-trixie-jemalloc-yjit

RUN apt-get update -y \
    && apt-get install -y build-essential m4 vim \
       autoconf automake cmake libtool \
       libzstd-dev libxml2-dev libyaml-dev \
       curl zstd libjemalloc-dev

RUN set -eux ; \
    mkdir /tmp/silesia ; cd /tmp/silesia ; \
    curl -sLfo silesia.tar.zstd https://f002.backblazeb2.com/file/xb1-p-public/silesia.tar.zstd && \
    zstd -d silesia.tar.zstd && tar xf silesia.tar && \
    cp -rf /tmp/silesia/silesia /silesia && \
    rm -rf /tmp/silesia

RUN gem update --system && gem install bundler

WORKDIR /app

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

RUN bundle config set --local deployment true \
    && bundle install

COPY . /app

CMD ["cd /app && bundle exec ruby main.rb"]
ENTRYPOINT ["/bin/bash", "-c"]
