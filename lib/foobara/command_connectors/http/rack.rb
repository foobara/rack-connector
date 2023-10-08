module Foobara
  module CommandConnectors
    class Http < Foobara::CommandConnector
      class Rack < Http
        def call(env)
          request = run(env)
          response = request.response
          [response.status, response.headers, [response.body]]
        rescue NoCommandFoundError, InvalidContextError => e
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
