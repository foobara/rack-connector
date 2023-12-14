module Foobara
  module CommandConnectors
    class Http < Foobara::CommandConnector
      class Rack < Http
        class Request < Http::Request
          attr_accessor :env

          def initialize(env)
            self.env = env

            # PATH_INFO has the path
            # REQUEST_URI has whole uri
            # QUERY_STRING has the query string
            # REQUEST_METHOD is the request method
            # rack.errors stream?
            # rack.input stream?
            # HTTP_ is all the headers
            super(
              path: env["PATH_INFO"],
              query_string: env["QUERY_STRING"],
              method: env["REQUEST_METHOD"],
              # TODO: should we delay this read instead of eager-loading this?
              body: env["rack.input"].read,
              headers: env.select { |s| s.start_with?("HTTP_") },
            )
          end
        end
      end
    end
  end
end
