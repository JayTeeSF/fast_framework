root_dir = File.expand_path(File.dirname(__FILE__) + "/..")
Dir["#{root_dir}/lib/**/base.rb", "#{root_dir}/lib/**/*.rb"].each {|f| require(f)}

FastFramework.config do |config|
  config.root = root_dir
  config.debug = false
  # add your app(s) here...
  # one app can manage the path itself
  config.map '/' => FastFramework::SampleApplication
  # or, you can map a different app to each url
  #config.map '/status' => FastFramework::HeartbeatApplication
  #config.map '/test' => FastFramework::TestApplication
end

FastFramework.welcome
