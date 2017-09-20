# frozen_string_literal: true

require "spec_helper"

RSpec.describe Medjay do
  let(:app) {
    Medjay::App.new(
      :path        => "alerts",
      :status_page => {:token => "secret", :page_id => "abc"}
    )
  }

  before :each do
    stub_request(
      :get, "https://api.statuspage.io/v1/pages/abc/components.json"
    ).to_return(:body => Oj.dump([{"name" => "northcote", "id" => 4}]))
  end

  it "returns a basic response for any unknown path" do
    get "/random"

    expect(last_response.body).to eq("Medjay")
    expect(last_response.status).to eq(200)
  end

  context "with a matching component" do
    before :each do
      stub_request(
        :patch, "https://api.statuspage.io/v1/pages/abc/components/4.json"
      )
    end

    it "returns an OK status" do
      post "/alerts", :message => Oj.dump(
        "action"    => "assign",
        "checkname" => "northcote"
      )

      expect(last_response.body).to eq("OK")
      expect(last_response.status).to eq(200)
    end

    it "sets assign actions as a major outage" do
      post "/alerts", :message => Oj.dump(
        "action"    => "assign",
        "checkname" => "northcote"
      )

      expect(a_request(
        :patch, "https://api.statuspage.io/v1/pages/abc/components/4.json"
        ).with(:body => {"component" => {"status" => "major_outage"}})
      ).to have_been_made.once
    end

    it "sets other actions as operational" do
      post "/alerts", :message => Oj.dump(
        "action"    => "resolved",
        "checkname" => "northcote"
      )

      expect(a_request(
        :patch, "https://api.statuspage.io/v1/pages/abc/components/4.json"
        ).with(:body => {"component" => {"status" => "operational"}})
      ).to have_been_made.once
    end
  end

  context "with no matching component" do
    it "returns an OK status" do
      post "/alerts", :message => Oj.dump(
        "action"    => "assign",
        "checkname" => "brunswick"
      )

      expect(last_response.body).to eq("OK")
      expect(last_response.status).to eq(200)
    end

    it "makes no request to StatusPage" do
      post "/alerts", :message => Oj.dump(
        "action"    => "assign",
        "checkname" => "brunswick"
      )

      expect(a_request(
        :patch, "https://api.statuspage.io/v1/pages/abc/components/4.json"
      )).not_to have_been_made
    end
  end
end
