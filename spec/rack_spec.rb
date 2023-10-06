RSpec.describe Foobara::CommandConnectors::Http::Rack do
  include Rack::Test::Methods

  let(:app) { command_connector }
  let(:command_connector) { described_class.new(default_serializers:) }
  let(:default_serializers) { Foobara::CommandConnectors::JsonSerializer }

  context "when no command" do
    it "is 404" do
      get "/run/CalculateExponent"

      expect(last_response.status).to be(404)
      expect(last_response.body).to include("Could not find command registered for CalculateExponent")
    end
  end

  context "when invalid context" do
    it "is 404" do
      get "/invalid_action/CalculateExponent"

      expect(last_response.status).to be(404)
      expect(last_response.body).to include("Not sure what to do with invalid_action")
    end
  end

  context "when command exists" do
    let(:command_class) do
      stub_class = ->(klass) { stub_const(klass.name, klass) }

      Class.new(Foobara::Command) do
        class << self
          def name
            "CalculateExponent"
          end
        end

        stub_class.call(self)

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
    end

    before do
      command_connector.connect(command_class)
    end

    it "is 200" do
      get "/run/CalculateExponent?base=2&exponent=3"

      expect(last_response.status).to be(200)
      expect(last_response.body).to eq("8")
    end
  end
end
