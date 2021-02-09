FROM ruby:3.0-slim-buster

RUN apt-get update -qq && apt-get install -y sendmail git build-essential

ENV APP_ROOT /var/www/briefkasten
RUN mkdir -p $APP_ROOT
WORKDIR $APP_ROOT
ADD Gemfile* $APP_ROOT/
RUN bundle install
ADD . $APP_ROOT

EXPOSE 3000

CMD ["bundle", "exec", "thin", "start"]
