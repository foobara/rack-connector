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
              cookies_string = nil

              cookies.each do |cookie|
                cookie_string = ::Rack::Utils.set_cookie_header(
                  cookie.name,
                  cookie.opts.merge(value: cookie.value)
                )

                cookies_string = if cookies_string
                                   [*cookies_string, cookie_string]
                                 else
                                   cookie_string
                                 end
              end

              add_header("set-cookie", cookies_string)
            end
          end
        end
      end
    end
  end
end
