source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.1.3'
# Use mysql as the database for Active Record
gem 'mysql2', '~> 0.5'
# Use Puma as the app server
gem 'puma', '~> 5.0'
# Use Redis adapter
gem 'redis', '~> 4.0'
# Serializing to json:api
gem 'jsonapi-serializer', '~> 2.2'
# Support for soft-delete
gem 'discard', '~> 1.2'
# Support for pagination
gem 'pagy', '~> 4.1'
# Support for background jobs
gem 'sidekiq', '~> 6.0'
gem 'sidekiq-scheduler', '~> 3.0'
# Support for kafka consumers
gem 'racecar', '~> 2.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i(mri mingw x64_mingw)
  gem 'rspec-rails'
  gem 'factory_bot'
  gem 'rubocop'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
  gem 'rubocop-performance'
  gem 'rubocop-thread_safety'
  gem 'reek'
end

group :development do
  gem 'listen', '~> 3.3'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

# Use tzinfo-data to be independent from linux timezone db
gem 'tzinfo-data'
