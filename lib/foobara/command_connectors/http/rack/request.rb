module Foobara
  module CommandConnectors
    class Http < Foobara::CommandConnector
      class Rack < Http
        class Request < Http::Request
          attr_accessor :env

          def initialize(env, prefix: nil)
            self.env = env

            scheme = if env["HTTP_X_FORWARDED_PROTO"] == "https" || env["HTTPS"] == "on"
                       "https"
                     else
                       "http"
                     end

            super(
              scheme:,
              host: env["SERVER_NAME"],
              port: env["SERVER_PORT"],
              path: env["PATH_INFO"],
              query_string: env["QUERY_STRING"],
              method: env["REQUEST_METHOD"],
              # TODO: should we delay this read instead of eager-loading this?
              body: env["rack.input"]&.read || "",
              headers: env.select { |s| s.start_with?("HTTP_") },
              cookies: ::Rack::Utils.parse_cookies(env),
              remote_ip: env["REMOTE_ADDR"],
              prefix:
            )
          end
        end
      end
    end
  end
end
