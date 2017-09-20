# frozen_string_literal: true

require "rubygems"
require "bundler"

Bundler.setup :default
$:.unshift File.dirname(__FILE__) + "/lib"

require "medjay"

run Medjay::App.new(
  :path        => ENV["MEDJAY_PATH"],
  :status_page => {
    :uri     => ENV["STATUSPAGE_API_URI"],
    :token   => ENV["STATUSPAGE_OAUTH_TOKEN"],
    :page_id => ENV["STATUSPAGE_PAGE_ID"]
  }
)
