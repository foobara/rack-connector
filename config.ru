require "bundler/setup"

require "foobara/rack_connector"

require "irb"
require "pry"

# run do |env|
#   [200, {}, ["Hello World"]]
# end

run Foobara::CommandConnectors::Http::Rack.new
