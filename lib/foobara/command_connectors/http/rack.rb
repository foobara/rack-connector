module Foobara
  module Connectors
    module Http
      class Rack
        attr_accessor :command_registry

        def initialize
          command_registry.new
        end

        def connect(command_class,
                    inputs_transformer:,
                    result_transformer:,
                    errors_transformer:,
                    allowed_rule:)

          self.command_class = command_class
          self.inputs_transformer = inputs_transformer
          self.result_transformer = result_transformer
          self.errors_transformer = errors_transformer
          self.allowed_rule = allowed_rule
        end

        def call(env)
        end
      end
    end
  end
end
