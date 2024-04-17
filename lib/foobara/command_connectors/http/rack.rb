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
          # :nocov:
          env["rack.errors"].puts e.to_s
          env["rack.errors"].puts e.backtrace

          raise e
          # :nocov:
        end
      end
    end
  end
end
