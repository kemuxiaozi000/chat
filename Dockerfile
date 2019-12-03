FROM ruby:2.5.1

# ARG http_proxy="http://10.74.169.139:8080"
# ARG https_proxy="http://10.74.169.139:8080"

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
  apt-get -qq update && \
  apt-get -qq -y install --no-install-recommends \
  nodejs graphviz build-essential libpq-dev postgresql-client apt-transport-https libopencv-dev && \
  apt-get clean && rm -rf /var/cache/apt/ && rm -rf /var/lib/apt/lists/*

# RUN npm config set registry https://registry.npm.taobao.org
RUN npm install -g yarn

ENV APP_ROOT /opt/application/current
RUN mkdir -p $APP_ROOT
WORKDIR $APP_ROOT

### Install packages and gems
COPY Gemfile ${APP_ROOT}/Gemfile
COPY Gemfile.lock ${APP_ROOT}/Gemfile.lock
RUN bundle install

ADD package.json ${APP_ROOT}/package.json
ADD yarn.lock ${APP_ROOT}/yarn.lock
RUN yarn install --pure-lockfile

ADD package.json ${APP_ROOT}/package.json
# ADD yarn.lock ${APP_ROOT}/yarn.lock
# RUN yarn config set registry https://registry.npm.taobao.org
# RUN yarn install --pure-lockfile

# RUN npm install -g eslint
# RUN npm i cos-js-sdk-v5 --save

# ENV NO_PROXY=db,elasticsearch

COPY . /opt/application/current

ENTRYPOINT ["sh", "./script/web_entrypoint.sh"]