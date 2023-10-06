module Foobara
  module CommandConnectors
    class Http < Foobara::CommandConnector
      class Rack < Http
        def call(env)
          # PATH_INFO has the path
          # REQUEST_URI has whole uri
          # QUERY_STRING has the query string
          # REQUEST_METHOD is the request method
          # rack.errors stream?
          # rack.input stream?
          # HTTP_ is all the headers

          path = env["PATH_INFO"]
          query_string = env["QUERY_STRING"]
          method = env["REQUEST_METHOD"]
          body = env["rack.input"].read
          headers = env.select { |s| s.start_with?("HTTP_") }

          begin
            request = run(path:, method:, headers:, query_string:, body:)
            response = request.response
            [response.status, response.headers, [response.body]]
          rescue NoCommandFoundError => e
            [404, {}, [e.message]]
          rescue InvalidContextError => e
            # should call the next app if we have one...
            if @app
              @app.call(env)
            else
              [404, {}, [e.message]]
            end
          rescue => e
            env["rack.errors"].puts e.to_s
            env["rack.errors"].puts e.backtrace

            raise e
          end
        end
      end
    end
  end
end
