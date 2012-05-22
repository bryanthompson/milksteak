require "rubygems"
require "bundler"
Bundler.require
require "rack/test"
require 'webmock/rspec'

ENV['RACK_ENV'] ||= "test"
WebMock.disable_net_connect!

Dir.glob("#{File.dirname(__FILE__)}/../lib/*.rb").each { |f| require f }

RSpec.configure do |config|
  config.include Rack::Test::Methods
end

