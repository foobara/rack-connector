RSpec.describe Foobara::CommandConnectors::Http::Rack do
  include Rack::Test::Methods

  let(:app) { described_class.new(default_serializers:) }
  let(:default_serializers) { Foobara::CommandConnectors::JsonSerializer }

  context "when no command" do
    it "is 200" do
      get "/run/CalculateExponent"

      expect(last_response.status).to be(404)
      expect(last_response.body).to include("Could not find command registered for CalculateExponent")
    end
  end
end
