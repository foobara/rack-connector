require "bundler/setup"

require "irb"
require "pry"

require "foobara/rack_connector"

run Foobara::CommandConnectors::Http::Rack.new
