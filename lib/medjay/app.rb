# frozen_string_literal: true

class Medjay::App
  attr_reader :path, :status_page

  def initialize(options)
    @path        = "/#{options[:path]}"
    @status_page = Medjay::StatusPage.new options[:status_page]
  end

  def call(env)
    request = Rack::Request.new env
    return [200, {}, ["Medjay"]] unless request.path == path

    Medjay::Request.call status_page, request
  end
end
