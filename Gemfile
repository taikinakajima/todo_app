source 'https://rubygems.org'
gem 'sinatra', :github => 'sinatra/sinatra'

gem 'sinatra-contrib'
gem 'activerecord'
gem 'sinatra-activerecord' , :require => 'active_support/all'
gem 'pg'
gem 'rake'

group :development do
  gem 'pg'
end

group :production do
  gem 'pg'
  gem "activerecord-postgresql-adapter"
end