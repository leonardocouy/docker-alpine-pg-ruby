A minimalist :dolphin: docker image for **Ruby** based on latest **[Alpine Linux](https://hub.docker.com/_/alpine/)**. 

**This image is not based on ruby:alpine**. Using this image you're able to use the latest Alpine Linux version and install any ruby version.

## What is this?

- :whale: Lightweight docker image based on top of latest Alpine Linux image;
- :gem: Supports **any** **Ruby** version (*Don't need pull other image version*);
- :package: Ready to bundler usage;
- :elephant: Ready to **PostgreSQL** usage (**if you use pg gem**);
- :hammer: Ready to build gem with native extensions (like **Nokogiri**);
- :stuck_out_tongue: Ready to run Rails + PostgreSQL application.

## Specifying a Ruby Version

**By default, if you not specify a Ruby version, it will install latest ruby version** 

You may pass the argument `RUBY_VERSION` with specific Ruby version when build your Docker image (based on this image) or Docker Compose. Like:


**When you build a Docker image from a Dockerfile**
```shell
docker build -t "my-alpine-ruby" . --build-arg RUBY_VERSION=2.3.1
```

**Docker-compose**
```yaml
version: '3'
services:
  ...
  web:
    ...
    build:
      context: .
      args:
        - RUBY_VERSION=2.3.1
    ...
  ...
```

## Contact

Built with :heart: by **Leonardo Flores (contato@leonardocouy.com)**
