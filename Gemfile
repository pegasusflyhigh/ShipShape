# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.3.0'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 7.0.4', '>= 7.0.4.2'

# Use pg as the database for Active Record
gem 'pg'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '~> 5.0'

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
# gem "jbuilder"

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem "rack-cors"

# Catch unsafe migrations in development
gem 'strong_migrations'
# Migrate data across all envs alongside schema migrations
gem 'data_migrate', '~> 9.4'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  # Pretty print Ruby objects during debugging to visualize their structure
  gem 'awesome_print'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  # RSpec support for Rails
  gem 'rspec-parameterized', '~> 1.0'
  gem 'rspec-rails', '~> 6'
  # Generate fake data
  gem 'faker'
  # Mock Rails models
  gem 'factory_bot_rails'
  # Simple one-liner tests for common Rails functionality
  gem 'shoulda-matchers'
  gem 'simplecov'
  gem "test-prof", "~> 1.0"
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
  # Annotates Rails/ActiveRecord Models, routes, fixtures, and others based on the database schema
  gem 'annotate'
  # Detects security vulnerabilities
  gem 'brakeman'
  # Code metric tool
  gem 'rails_best_practices', require: false
  # Detects N+1 queries and unused eager loading
  gem 'bullet', '~> 7'
  # Code style checking and code formatting tool
  gem 'rubocop', '~> 1', require: false
  # Check for performance optimizations
  gem 'rubocop-performance', require: false
  # RuboCop extension focused on enforcing Rails best practices and coding conventions
  gem 'rubocop-rails', require: false
  # RuboCop extension focused on enforcing RSpec best practices and coding conventions
  gem 'rubocop-rspec', '~> 2', require: false
end
