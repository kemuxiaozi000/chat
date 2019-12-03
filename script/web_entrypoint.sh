date +%Y%m%d%H%I%s
yarn install --pure-lockfile --network-timeout 1000000
if [ "${RAILS_ENV}" = "production" ]; then
  rake assets:precompile
fi
bundle exec unicorn -c config/unicorn.rb -E $RAILS_ENV -l 3000
