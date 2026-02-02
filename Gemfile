source "https://rubygems.org"

gem "rails", "~> 8.0.2"
gem "propshaft"
gem "pg", "~> 1.5"
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "tailwindcss-rails"
gem "jbuilder"
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "solid_cache"
gem "solid_queue"
gem "bootsnap", require: false
gem "kamal", require: false
gem "thruster", require: false
gem 'groupdate'

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
  gem "overcommit", require: false
end

group :development do
  gem "web-console"
  gem "capistrano", "~> 3.17", require: false
  gem "capistrano-rails", "~> 1.4", require: false
  gem "capistrano-rbenv", "~> 2.2", require: false
  gem "capistrano-passenger"
  gem "capistrano-solid_queue", require: false
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "minitest", "~> 6.0"
end

gem "bcrypt", "~> 3.1"
