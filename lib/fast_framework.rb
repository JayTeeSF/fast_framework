module FastFramework
  extend self
  extend Route

  attr_accessor :root, :debug

  def welcome
    puts "Welcome to FastFramework v#{VERSION}"
  end

  def log &block
    puts yield if debug && block_given?
  end
end
