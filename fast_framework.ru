require "#{File.expand_path(File.dirname(__FILE__))}/config/init.rb"

app = Rack::Builder.app do
  FastFramework.routes.each_pair do |pattern, application|
    map(pattern) { run(application) }
  end
end

run app
