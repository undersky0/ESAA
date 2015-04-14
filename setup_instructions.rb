spring binstub --all
spring status
rails g
rails g rspec:install
guard init

in guard file: guard :rspec, cmd:"spring rspec" do


in rspec config add:

require 'rubygems'
require 'factory_girl'

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end

host: localhost
port: 5432
pool: 5
username: postgres
password: password

elastic search start:
    elasticsearch --config=/usr/local/opt/elasticsearch/config/elasticsearch.yml
    elasticsearch --config=/usr/local/var/elasticsearch_1a/config/elasticsearch.yml
