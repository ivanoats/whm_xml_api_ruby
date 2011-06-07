require 'rubygems'
require 'bundler/setup'
$:.push File.expand_path("../lib", __FILE__)
require 'whm'

# Enable mocha mocking/stubbing
RSpec.configure do |c|
  c.mock_with :mocha
end

def stdout_for(&block)
  # Inspired by http://www.ruby-forum.com/topic/58647
  old_stdout = $stdout
  $stdout = StringIO.new
  yield
  output = $stdout.string
  $stdout = old_stdout
  output
end