module Foobara
  # TODO: move to foobara monorepo if this is generic...
  class CommandConnector
    class Entry
      attr_accessor :command_class,
                    :inputs_transformer,
                    :result_transformer,
                    :errors_transformer,
                    :allowed_rule

      def register(command_class, inputs_transformer:, result_transformer:, errors_transformer:, allowed_rule:)
        self.command_class = command_class
        self.inputs_transformer = inputs_transformer
        self.result_transformer = result_transformer
        self.allowed_rule = allowed_rule
        self.errors_transformer = errors_transformer
      end
    end

    class AllowedRule
      attr_accessor :block, :explanation, :symbol

      def initialize(symbol: nil, explanation: nil, &block)
        self.symbol = symbol
        self.block = block
        self.explanation = explanation
      end

      def call
        block.call
      end
    end

    class << self
      attr_accessor :default_inputs_transformer,
                    :default_result_transformer,
                    :default_errors_transformer,
                    :default_allowed_rule
    end

    foobara_delegate :default_inputs_transformer,
                     :default_result_transformer,
                     :default_errors_transformer,
                     :default_allowed_rule,
                     to: :class

    def connect(
      command_class,
      inputs_transformer = default_inputs_transformer,
      result_transformer = default_result_transformer,
      errors_transformer = default_errors_transformer,
      allowed_rule = default_allowed_rule
    )
      entry = Entry.new(
        command_class,
        inputs_transformer:,
        result_transformer:,
        errors_transformer:,
        allowed_rule:
      )

      registry[command_class.full_entity_name] = entry
    end

    def registry
      @registry ||= {}
    end

    def allowed_rule_registry
      @allowed_rule_registry ||= {}
    end

    def allowed_rule(ruleish)
      allowed_rule = to_allowed_rule(ruleish)

      unless allowed_rule.symbol
        raise "Cannot register a rule without a symbol"
      end

      @allowed_rule_registry[allowed_rule.symbol] = allowed_rule
    end

    def allowed_rules(hash)
      hash.map do |symbol, ruleish|
        allowed_rule = to_allowed_rule(ruleish)
        allowed_rule.symbol = symbol

        allowed_rule(allowed_rule)
      end
    end

    def to_allowed_rule(object)
      case object
      when ::AllowedRule
        object
      when ::String
        to_allowed_rule(object.to_sym)
      when ::Symbol
        allowed_rule = allowed_rule_registry[object]

        unless allowed_rule
          raise "No allowed rule found for #{object}"
        end

        allowed_rule
      when ::Hash
        rule_attributes = allowed_rule_attributes_type.process_value!(object)

        allowed_rule = to_allowed_rule(object[:logic])

        allowed_rule.symbol = rule_attributes[:symbol]
        allowed_rule.explanation ||= rule_attributes[:explanation]

        allowed_rule
      when ::Array
        rules = object.map { |ruleish| to_allowed_rule(ruleish) }

        procs = rules.map(&:block)

        block = proc do
          procs.any?(&:call)
        end

        allowed_rule = AllowedRule.new(&block)

        if rules.all?(&:explanation)
          allowed_rule.explanation = Util.to_or_sentence(rules.map(&:explanation))
        end

        allowed_rule
      else
        if object.respond_to?(:call)
          AllowedRule.new(&object)
        else
          raise "Not sure how to convert #{object} into an AllowedRule object"
        end
      end
    end

    def allowed_rule_attributes_type
      @allowed_rule_attributes_type ||= TypeDeclarations::Namespace.global.type_for_declaration(
        symbol: :symbol,
        explanation: :string,
        logic: :duck
      )
    end
  end
end
