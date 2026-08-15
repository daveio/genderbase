# frozen_string_literal: true

source "https://rubygems.org" # https://github.com/rubygems/rubygems

ruby "4.0.6"

gem "rails"                  # https://github.com/rails/rails
gem "fileutils"              # https://github.com/ruby/fileutils
gem "propshaft"              # https://github.com/rails/propshaft
gem "sqlite3"                # https://github.com/sparklemotion/sqlite3-ruby
gem "puma"                   # https://github.com/puma/puma
gem "jsbundling-rails"       # https://github.com/rails/jsbundling-rails
gem "cssbundling-rails"      # https://github.com/rails/cssbundling-rails
gem "turbo-rails"            # https://turbo.hotwired.dev
gem "stimulus-rails"         # https://stimulus.hotwired.dev
gem "jbuilder"               # https://github.com/rails/jbuilder
gem "bcrypt"                 # https://github.com/bcrypt-ruby/bcrypt-ruby
gem "tzinfo-data", platforms: %i[ windows jruby ] # https://github.com/tzinfo/tzinfo-data
gem "solid_cache"            # https://github.com/rails/solid_cache
gem "solid_queue"            # https://github.com/rails/solid_queue
gem "solid_cable"            # https://github.com/rails/solid_cable
gem "devise"                 # https://github.com/heartcombo/devise
gem "devise-argon2"          # https://github.com/erdostom/devise-argon2
gem "devise_zxcvbn"          # https://github.com/bitzesty/devise_zxcvbn
gem "kramdown"               # https://github.com/gettalong/kramdown
gem "image_processing"       # https://github.com/janko/image_processing
gem "bootsnap", require: false # https://github.com/Shopify/bootsnap
gem "kamal", require: false  # https://kamal-deploy.org
gem "thruster", require: false # https://github.com/basecamp/thruster
gem "foreman", require: false # https://github.com/ddollar/foreman

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude" # https://github.com/ruby/debug
  gem "brakeman", require: false # https://brakemanscanner.org
  gem "log_bench" # https://github.com/silva96/log_bench
  gem "rubocop", require: false # https://github.com/rubocop/rubocop
  gem "solargraph", require: false # https://github.com/castwide/solargraph
  gem "rubocop-rails-omakase", require: false # https://github.com/rails/rubocop-rails-omakase
  gem "pry", require: false  # https://github.com/pry/pry
  gem "pry-theme", require: false # https://github.com/pry/pry-theme
end

group :development do
  gem "web-console"          # https://github.com/rails/web-console
  gem "hotwire-livereload"   # https://github.com/hotwired/hotwire-livereload
end

group :test do
  gem "capybara"             # https://github.com/teamcapybara/capybara
  gem "selenium-webdriver"   # https://github.com/SeleniumHQ/selenium
  gem "simplecov", require: false # https://github.com/simplecov-ruby/simplecov
end
