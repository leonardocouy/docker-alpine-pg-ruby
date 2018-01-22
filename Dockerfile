FROM alpine:3.7
LABEL maintainer="Leonardo Flores <contato@leonardocouy.com>"

ARG RUBY_VERSION

ENV BUILD_DEPS="curl tar wget linux-headers" \
    DEV_DEPS="build-base postgresql-dev zlib-dev libxml2-dev libxslt-dev readline-dev tzdata git nodejs"

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

## Install bundler, disable bundler warning and prevents install gem documentations
RUN gem install -N bundler \
  && bundle config --global silence_root_warning 1 \
  && echo -e 'gem: --no-document' >> /etc/gemrc

# Clean and uninstall
RUN apk del $BUILD_DEPS \
  && rm -rf /var/cache/apk/* \
  && rm -rf /usr/lib/ruby/gems/*/cache/*;
