require "rails_helper"

RSpec.describe FyberOffersController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/fyber_offers").to route_to("fyber_offers#index")
    end

  end
end
