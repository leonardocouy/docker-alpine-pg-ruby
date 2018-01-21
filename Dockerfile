FROM alpine:3.7
MAINTAINER Leonardo Flores <contato@leonardocouy.com>

RUN apk add --no-cache --update --upgrade curl wget

ARG RUBY_VERSION
ARG RUBYGEMS_VERSION

RUN \
  RUBY_VERSION_LIST="https://raw.githubusercontent.com/postmodern/ruby-versions/master/ruby/versions.txt" \
  && LATEST_RUBY_VERSION=$(\curl -sS $RUBY_VERSION_LIST| tail -1) \
  && echo Installing Ruby ${RUBY_VERSION:-$LATEST_RUBY_VERSION} \
  && wget -L "http://ftp.ruby-lang.org/pub/ruby/ruby-${RUBY_VERSION:-$LATEST_RUBY_VERSION}.tar.gz"
