# Briefkasten

Small postbox app: fill out a form, send via email

## Setup

``` bash
$ cp env.sample .env
```
Edit the values in the .env and then `source .env`. Install dependencies and start server with:

``` bash
$ bundle install && bundle exec thin start
```

To start mailcatcher in development for testing emails run

``` bash
$ bundle exec mailcatcher
```

## Docker

There is a Dockerfile you can use, a potential docker-compose.yml could look like this

``` yaml

```
