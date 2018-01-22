FROM alpine:3.7
LABEL maintainer="Leonardo Flores <contato@leonardocouy.com>"

ARG RUBY_VERSION

ENV BUILD_DEPS="curl tar wget linux-headers" \
    DEV_DEPS="build-base postgresql-dev zlib-dev libxml2-dev libxslt-dev tzdata git"

RUN apk add --update --upgrade $BUILD_DEPS $DEV_DEPS

## Install specified ruby version
## if ruby version is not present, it will install latest ruby version
RUN \
  RUBY_VERSION_LIST="https://raw.githubusercontent.com/postmodern/ruby-versions/master/ruby/versions.txt" \
  && LATEST_RUBY_VERSION=$(\curl -sS $RUBY_VERSION_LIST| tail -1) \
  && SELECTED_RUBY_VERSION=${RUBY_VERSION:-$LATEST_RUBY_VERSION} \
  && echo Installing Ruby $SELECTED_RUBY_VERSION \
  && wget -L "http://ftp.ruby-lang.org/pub/ruby/ruby-$SELECTED_RUBY_VERSION.tar.gz" \
  && tar xvzf ruby-$SELECTED_RUBY_VERSION.tar.gz \
  && rm ruby-$SELECTED_RUBY_VERSION.tar.gz \
  && cd ruby-$SELECTED_RUBY_VERSION \
  && export ac_cv_func_isnan=yes ac_cv_func_isinf=yes \
  && ./configure --enable-shared --disable-install-doc \
  && make -j 4 \
  && make install \
  && rm -rf /ruby-$RUBY_VERSION

## Install bundler
RUN gem install -N bundler

## Disable bundler warning
RUN bundle config --global silence_root_warning 1

## Prevents install gem documentation
RUN echo -e 'gem: --no-document' >> /etc/gemrc

# Clean and uninstall
RUN apk del $BUILD_DEPS
RUN rm -rf /var/cache/apk/*
RUN rm -rf /usr/lib/ruby/gems/*/cache/*;
