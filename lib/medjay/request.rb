class Medjay::Request
  def self.call(status_page, request)
    new(status_page, request).call
  end

  def initialize(status_page, request)
    @status_page = status_page
    @request     = request
  end

  def call
    status_page.update_component component["id"], status if component

    [200, {"Content-Type" => "text/plain"}, ["OK"]]
  end

  private

  attr_reader :status_page, :request

  def component
    @component ||= status_page.components.detect { |hash|
      hash["name"].downcase == json["checkname"][/\A[a-z]+/]
    }
  end

  def json
    @json ||= Oj.load request.params["message"]
  end

  def status
    (json["action"] == "assign") ? "major_outage" : "operational"
  end
end
