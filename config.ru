require "bundler/setup"

require "irb"
require "pry"

require "foobara/rack_connector"

app = Foobara::CommandConnectors::Http::Rack.new(default_serializers: Foobara::CommandConnectors::JsonSerializer)

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

app.connect(CalculateExponent)

run app
