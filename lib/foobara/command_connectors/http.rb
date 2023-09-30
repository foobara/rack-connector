module Foobara
  module Connectors
    class Http < CommandConnector
      def route(request)
        response = case action
                   when "run"
                     registry_entry = command_registry[command_name]

                     unless registry_entry
                       Response.new(404, {}, "No command found for #{command_name}")
                     end

                     outcome = run_command(registry_entry, request.inputs)
                     outcome_to_response(registry_entry, outcome)
                   when "manifest"
                     get_manifest
                   when "commands"
                     get_commands
                   when "types"
                     get_types
                   when "entities"
                     get_entities
                   end

        response || Response.new(404, {}, "No route for #{action}")
      end

      def run_command(registry_entry, inputs)
        command_class = registry_entry.command_class
        inputs = registry_entry.transform_inputs(inputs)

        command = command_class.new(inputs)

        reasons = not_allowed_to_run_reasons(registry_entry, command)

        command.run
      end

      def not_allowed_to_run_reasons(registry_entry, command)
        # TODO: Need to move the command into the load_records state but not close the transaction...
        allowed_rules = registry_entry.allowed_rules

        if allowed_rules.any? do |allowed_rule|
          block = proc do
            allowed_rule.block.call(request)
          end

          command.instance_eval(&allowed_rule.block)
        end
        end
      end

      def outcome_to_response(registry_entry, outcome)
        if outcome.success?
          body = registry_entry.transform_result(outcome.result)
          Request.new(200, {}, body)
        else
          body = registry_entry.transform_errors(outcome.errors)
          Request.new(422, {}, body)
        end
      end
    end
  end
end
