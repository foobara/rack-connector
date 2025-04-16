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
              headers: extract_headers,
              cookies: ::Rack::Utils.parse_cookies(env),
              remote_ip: env["REMOTE_ADDR"],
              prefix:
            )
          end

          private

          def extract_headers
            headers = {}

            env.each_pair do |key, value|
              next unless key.start_with?("HTTP_")

              header_name = key[5..].downcase.gsub("_", "-")

              headers[header_name] = value
            end

            headers
          end
        end
      end
    end
  end
end
