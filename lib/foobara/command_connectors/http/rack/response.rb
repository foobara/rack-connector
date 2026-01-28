module Foobara
  module CommandConnectors
    class Http < CommandConnector
      class Rack < Http
        class Response < Http::Response
          def initialize(...)
            super
            update_set_cookie_header
          end

          def add_cookie(...)
            super
            update_set_cookie_header
          end

          private

          def update_set_cookie_header
            if cookies && !cookies.empty?
              cookie_strings = cookies.map do |cookie|
                ::Rack::Utils.set_cookie_header(
                  cookie.name,
                  cookie.opts.merge(value: cookie.value)
                )
              end

              add_header("set-cookie", cookie_strings)
            end
          end
        end
      end
    end
  end
end
