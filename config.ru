require 'rack'
require 'json'
require 'faraday'

module Medjay
  class Request
    URI         = ENV['STATUSPAGE_API_URI'] || 'https://api.statuspage.io'
    OAUTH_TOKEN = ENV['STATUSPAGE_OAUTH_TOKEN']
    PAGE_ID     = ENV['STATUSPAGE_PAGE_ID']

    def self.call(env)
      new(env).call
    end

    def initialize(env)
      @env = env
    end

    def call
      connection.patch "/v1/pages/#{PAGE_ID}/components/#{component['id']}.json", "component[status]=#{status}" if component

      [200, {'Content-Type' => 'text/plain'}, ['OK']]
    end

    private

    attr_reader :env

    def component
      @component ||= components.detect { |hash|
        hash['name'].downcase == json['description'][/\A[a-z]+/]
      }
    end

    def components
      JSON.parse connection.get("/v1/pages/#{PAGE_ID}/components.json").body
    end

    def connection
      @connection ||= Faraday.new(:url => URI) do |faraday|
        faraday.request  :url_encoded
        faraday.response :logger
        faraday.adapter  Faraday.default_adapter
        faraday.headers = {'Authorization' => "OAuth #{OAUTH_TOKEN}"}
      end
    end

    def json
      @json ||= JSON.parse request.params['message']
    end

    def request
      Rack::Request.new env
    end

    def status
      (json['action'] == 'assign') ? 'major_outage' : 'operational'
    end
  end
end

run Medjay::Request
