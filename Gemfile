require_relative "version"

source "https://rubygems.org"
ruby Foobara::RackConnector::Version::MINIMUM_RUBY_VERSION

gemspec

# gem "foobara", path: "../foobara"
# gem "foobara-http-command-connector", path: "../http-command-connector"

group :development do
  gem "foobara-rubocop-rules", "~> 0.0.1"
  gem "rubocop-rake"
  gem "rubocop-rspec"
  gem "simplecov"
end

group :test do
  gem "foobara-spec-helpers", "~> 0.0.1"
  gem "guard-rspec"
  gem "rack-test"
  gem "rspec-its"
end

group :test, :development do
  gem "pry"
  gem "pry-byebug"
  # Need to load irb to silence warnings from pry for now
  gem "irb"
  gem "rackup"
  gem "rake"
  gem "rspec"
end
