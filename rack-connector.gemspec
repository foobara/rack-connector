require_relative "version"

Gem::Specification.new do |spec|
  spec.name = "foobara-rack-connector"
  spec.version = Rack::Connector::Version::VERSION
  spec.authors = ["Miles Georgi"]
  spec.email = ["azimux@gmail.com"]

  spec.summary = "Exposes foobara commands and entities via rack interface."
  spec.description = spec.summary
  spec.homepage = "https://github.com/foobara/rack-connector"
  spec.license = "none yet"
  spec.required_ruby_version = ">= #{File.read("#{__dir__}/.ruby-version")}"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/CHANGELOG.md"

  spec.files = Dir[
    "lib/**/*",
    "src/**/*",
    "LICENSE*.txt",
    "README.md",
    "CHANGELOG.md"
  ]

  spec.require_paths = ["lib"]
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.add_dependency "foobara"
  spec.add_dependency "foobara-http-command-connector"
  spec.add_dependency "foobara-util"
  spec.add_dependency "rack"
end
