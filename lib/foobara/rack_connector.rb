require "foobara/all"

module Foobara
  module Monorepo
    # Kind of awkward to not be able to just use require... or can we?
    # project "command_connectors"
    project "command_connectors_http"
  end

  Util.require_directory(__dir__)

  module RackConnector
  end
end
