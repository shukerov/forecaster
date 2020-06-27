FROM ruby:2.6

RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev

# install nodejs
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install -y nodejs

# install the moldy yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt update && apt install yarn

# RUN apt-get update && apt-get install -y yarn && rm -rf /var/lib/apt/lists/*

RUN mkdir /application
WORKDIR /application

COPY Gemfile* /application/
RUN bundle install

# Copy application code
COPY . /application

# precompile assets
RUN bundle exec rake assets:precompile

# install yarn packages
RUN yarn install && bundle exec rails webpacker:compile

CMD ["bin/rails","s","-b","0.0.0.0"]
