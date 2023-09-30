module Foobara
  module CommandConnectors
    class Http < CommandConnector
      class Rack
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

          request = Request.new(path, method, headers, query_string, body)

          response = begin
            route(request)
          rescue => e
            env["rack.errors"].puts e.to_s
            env["rack.errors"].puts e.backtrace

            Response.new(500, {}, "#{e}\n#{e.backtrace.inspect}")
          end

          [response.status, respone.headers, respone.body]
        end
      end
    end
  end
end
