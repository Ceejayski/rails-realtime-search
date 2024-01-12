# exit on error
set -o errexit

bundle install

bundle install
yarn install
./bin/rails assets:precompile
./bin/rails assets:clean
bundle exec rails db:migrate
bundle exec rails db:seed
