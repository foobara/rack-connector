require "bundler/setup"

require "irb"
require "pry"

require "foobara/rack_connector"

rack_command_connector = Foobara::CommandConnectors::Http::Rack.new(
  default_serializers: Foobara::CommandConnectors::JsonSerializer
)

class CalculateExponent < Foobara::Command
  inputs type: :attributes,
         element_type_declarations: {
           base: :integer,
           exponent: :integer
         },
         required: %i[base exponent]

  result :integer

  def execute
    base**exponent
  end
end

rack_command_connector.connect(CalculateExponent)

run rack_command_connector
