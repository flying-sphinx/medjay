# frozen_string_literal: true

ENV["RACK_ENV"] ||= "test"

require "rubygems"
require "bundler"
require "time"

Bundler.setup :default
Bundler.require :test

require "webmock/rspec"
WebMock.disable_net_connect!

$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require "medjay"

RSpec.configure do |config|
  config.include Rack::Test::Methods
end
