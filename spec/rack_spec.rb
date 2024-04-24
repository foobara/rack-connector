RSpec.describe Foobara::CommandConnectors::Http::Rack do
  include Rack::Test::Methods

  let(:app) { command_connector }
  let(:command_connector) { described_class.new(default_serializers:) }
  let(:default_serializers) { Foobara::CommandConnectors::Serializers::JsonSerializer }

  context "when no command" do
    it "is 404" do
      get "/run/CalculateExponent"

      expect(last_response.status).to be(404)
      expect(last_response.body).to include("Could not find command registered for CalculateExponent")
    end

    describe "/manifest" do
      it "gives a manifest with no commands or types" do
        get "/manifest"

        expect(last_response.status).to be(200)
        manifest = JSON.parse(last_response.body)

        expect(manifest.keys).to match_array(
          %w[
            organization
            domain
            type
            command
            error
            processor
            processor_class
            metadata
          ]
        )
        expect(manifest["type"]).to eq({})
      end
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
      stub_class "CalculateExponent", Foobara::Command do
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
      get "/run/CalculateExponent?base=2&exponent=3", nil, { "HTTP_X_FORWARDED_PROTO" => "https" }

      expect(last_response.status).to be(200)
      expect(last_response.body).to eq("8")
    end
  end
end
