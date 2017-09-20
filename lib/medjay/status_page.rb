# frozen_string_literal: true

class Medjay::StatusPage
  attr_reader :uri, :token, :page_id

  def initialize(options)
    @uri     = options[:uri] || "https://api.statuspage.io"
    @token   = options[:token]
    @page_id = options[:page_id]
  end

  def components
    Oj.load connection.get("/v1/pages/#{page_id}/components.json").body
  end

  def update_component(id, status)
    connection.patch(
      "/v1/pages/#{page_id}/components/#{id}.json",
      "component[status]=#{status}"
    )
  end

  private

  def connection
    @connection ||= Faraday.new(:url => uri) do |faraday|
      faraday.request  :url_encoded
      faraday.response :logger unless ENV["RACK_ENV"] == "test"
      faraday.adapter  Faraday.default_adapter
      faraday.headers = {"Authorization" => "OAuth #{token}"}
    end
  end
end
