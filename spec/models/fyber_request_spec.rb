require 'rails_helper'

RSpec.describe FyberRequest, :type => :model do
  it "calculates hashkey correctly" do
    allow(Rails.application.secrets).to receive(:fyber_api_key).and_return('e95a21621a1865bcbae3bee89c4d4f84')
    request = FyberRequest.new(FactoryGirl.attributes_for(:fyber_request))
    expect(request.hashkey).to eq('7a2b1604c03d46eec1ecd4a686787b75dd693c4d')
  end
  
  it 'verifies the response signature correctly' do
    body = "{\"code\":\"NO_CONTENT\",\"message\":\"Successful request, but no offers are currently available for this user.\",\"count\":0,\"pages\":0,\"information\":{\"app_name\":\"Demo iframe for publisher - do not touch\",\"appid\":157,\"virtual_currency\":\"Coins\",\"country\":\"CO\",\"language\":\"DE\",\"support_url\":\"http://api.sponsorpay.com/support?appid=157&feed=on&mobile=on&uid=player1\"},\"offers\":[]}"
    request = FyberRequest.new(FactoryGirl.attributes_for(:fyber_request))
    expect(request.response_signature(body)).to eq('1510784bbb0a3f9064fb89e59e1c3b2562a77863')
  end
end
