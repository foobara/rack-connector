# run do |env|
#   [200, {}, ["Hello World"]]
# end

require "foobara/rack_connector"

run Foobara::CommandConnectors::Http::Rack.new
