# run do |env|
#   [200, {}, ["Hello World"]]
# end

class App
  def call(env)
    puts env

    [200, {}, ["Hello World"]]
  end
end

run App.new
