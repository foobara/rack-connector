module Foobara
  module CommandConnectors
    class Http < Foobara::CommandConnector
      class Rack < Http
        # Just a convenience method for demos. In real projects use rackup/config.ru
        # or set it all up with `foob g rack-connector`
        def run_puma(**)
          # simplecov:disable
          require "puma"
          require "rack/handler/puma"

          ::Rack::Handler::Puma.run(self, **)
          # simplecov:enable
        end
      end
    end
  end
end
