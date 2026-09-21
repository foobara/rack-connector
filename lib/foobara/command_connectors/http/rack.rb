module Foobara
  module CommandConnectors
    class Http < Foobara::CommandConnector
      class Rack < Http
        def call(env)
          response = run(env)
          [response.status, response.headers, [response.body]]
        rescue NotFoundError, InvalidContextError => e
          [404, {}, [e.message]]
        rescue => e
          # simplecov:disable
          env["rack.errors"].puts e.to_s
          env["rack.errors"].puts e.backtrace

          raise e
          # simplecov:enable
        end
      end
    end
  end
end
