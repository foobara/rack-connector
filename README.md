[![Gem Version](https://badge.fury.io/rb/foobara-rack-connector.svg)](https://badge.fury.io/rb/foobara-rack-connector)

# Foobara::RackConnector
Rack connector for foobara gem.

## Installation

From this directory, run the following:

```
gem install foobara-rack-connector
```
or 
in Gemfile
```
gem "foobara-rack-connector"
```

## Usage
```ruby
command_connector = Foobara::CommandConnectors::Http::Rack.new
command_connector.connect(Add) # Your Foobara::Command should goes here
Rackup::Server.start(app: command_connector)
```
## Example
```ruby
require "foobara/rack_connector"
require "rackup/server"
require "foobara"

class Add < Foobara::Command
  inputs do
    operand1 :integer, :required
    operand2 :integer, :required
  end

  result :integer

  def execute
    add_operands
  end

  attr_accessor :sum

  def add_operands
    self.sum = operand1 + operand2
  end
end
command_connector = Foobara::CommandConnectors::Http::Rack.new

command_connector.connect(Add)

Rackup::Server.start(app: command_connector)
```

### Manifests

You can see the generated manifest by opening the url.
```http://localhost:9292/help/Add```
### Commands 
Command can be execute by sending 
```curl 'http://localhost:9292/run/Add?operand1=1&&operand2=2'```


## Development
After checking out the repo, run `bundle install` to install dependencies. Then, run `bundle exec rspec` to run the tests. You can also run bin/console for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in version.rb, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the .gem file to rubygems.org.

## Contributing

Bug reports and pull requests are welcome on GitHub
at https://github.com/foobara/rack-connector
## License

This project is licensed under the MPL-2.0 license. Please see LICENSE.txt for more info.
