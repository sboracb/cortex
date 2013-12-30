source 'https://rubygems.org'

gem 'rails', '~> 4.0'
gem 'jbuilder', '~> 1.2'
gem 'fog'
gem 'unf'
gem 'thin', require: false
gem 'rack-cors', require: 'rack/cors'
gem 'pg'

# ActiveRecord
gem 'apartment'
gem 'awesome_nested_set'
gem 'paperclip', '~> 3.0'
gem 'acts-as-taggable-on'
gem 'bcrypt-ruby', require: 'bcrypt'
gem 'annotate'
gem 'tire'
gem 'tire_async_index'
gem 'composite_primary_keys'

# Sidekiq
gem 'sidekiq'
gem 'sidekiq-failures'
gem 'sinatra', require: nil
gem 'slim' # For sidekiq-web

group :test, :development do
  gem 'rspec-rails'
  gem 'mocha', require: false
  gem 'rb-fsevent', require: RUBY_PLATFORM =~ /darwin/i ? 'rb-fsevent' : false
  gem 'factory_girl_rails'
  gem 'shoulda', require: false
  gem 'database_cleaner'
end

group :development do
  gem 'better_errors'
  gem 'foreman', require: false
  gem 'rspec-sidekiq'
end

group :test do
  gem 'guard-rspec'
end

ruby '2.0.0'
