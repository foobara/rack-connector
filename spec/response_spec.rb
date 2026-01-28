RSpec.describe Foobara::CommandConnectors::Http::Rack::Response do
  describe "#add_cookie" do
    let(:response) do
      described_class.new(request:)
    end
    let(:request) do
      Foobara::CommandConnectors::Http::Rack::Request.new(env)
    end
    let(:env) do
      {}
    end

    it "adds a set-cookie header" do
      response.add_cookie("foo", "bar", secure: true, httponly: true)
      response.add_cookie("bar", "baz")

      expect(response.headers["set-cookie"]).to eq(
        [
          "foo=bar; secure; httponly",
          "bar=baz"
        ]
      )
    end
  end
end
