source 'https://rubygems.org'

ruby '2.1.5'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.8'

# Use postgresql as the database for Active Record
gem 'pg'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'
gem "sprockets", "2.11.0"

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# Use debugger
# gem 'debugger', group: [:development, :test]

group :development, :test do
  gem 'rspec-rails', '~> 2.14'
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :development do
  gem 'capistrano'
  gem 'capistrano-rails'
  gem 'capistrano-bundler'
  gem 'capistrano-rvm'
end

group :test do
  gem 'shoulda-matchers'
  gem "shoulda-callback-matchers", ">=0.3.0"
end

group :production do
  gem 'unicorn'
end

gem 'factory_girl_rails', '~> 4.0'
gem 'devise'
gem 'kaminari'
gem 'cancan'
gem 'paperclip'
gem 'foreman'
gem 'rails-timeago', '~> 2.0'
gem "haml-rails"
gem 'momentjs-rails', '>= 2.8.1'
gem 'awesome_nested_fields'
gem 'opinio', :git => 'git://github.com/apricis/opinio4.git'

# # Added for backward compatibility of Opinio gem
# # (attr_accessible support)
# gem 'protected_attributes'

gem 'websocket-rails'
gem 'html_truncator', '~> 0.4.0'
gem 'remotipart'
gem 'public_activity'

# for resolving of undefined method `graft' for class `ActiveRecord::Associations::JoinDependency'
# which occured due to squeel gem
gem "polyamorous", '~> 1.1.0' # squeel deps
gem "ransack", '~> 1.6.5' # squeel deps
gem 'squeel', :github => "activerecord-hackery/squeel"
gem 'ckeditor'
gem 'time_diff'
gem 'jquery-countdown-rails'

gem 'semantic-ui-sass', github: 'doabit/semantic-ui-sass'
gem 'masonry-rails'

gem 'elasticsearch-model'
gem 'elasticsearch-rails'
gem 'fullcalendar-rails'