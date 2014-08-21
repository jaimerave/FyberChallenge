require 'rails_helper'

RSpec.describe "FyberOffers", :type => :feature do
  describe "GET /fyber_offers" do
    it "should show a search form" do
      visit fyber_offers_path
      
      expect(page).to have_content 'Fyber Offers'
      within(".form-horizontal") do
        fill_in 'fyber_offer[uid]', :with => 'player1'
      end
      click_button 'Submit'
      
      expect(page).to have_content 'Results'
    end
    
    it 'should show correct message when no offers' do
      allow_any_instance_of(FyberRequest).to receive(:get_offers).and_return(nil)
      allow_any_instance_of(FyberRequest).to receive(:message).and_return('Successful request, but no offers are currently available for this user.')
      visit fyber_offers_path
      
      expect(page).to have_content 'Fyber Offers'
      within(".form-horizontal") do
        fill_in 'fyber_offer[uid]', :with => 'player0'
      end
      click_button 'Submit'
      expect(page).to have_content 'Successful request, but no offers are currently available for this user.'
      expect(page).to have_content 'Results'
      expect(page).to have_content 'No offers'
    end
    
    it 'should show correct message when tampered signature' do
      allow_any_instance_of(HTTParty::Response).to receive(:headers).and_return({'x-sponsorpay-response-signature' => '12345'})
      visit fyber_offers_path
      
      expect(page).to have_content 'Fyber Offers'
      within(".form-horizontal") do
        fill_in 'fyber_offer[uid]', :with => 'player1'
      end
      click_button 'Submit'
      expect(page).to have_content 'Tampered response. Invalid Signature'
      expect(page).to have_content 'Results'
      expect(page).to have_content 'No offers'
    end
    
    it 'should show correct results when offers available' do
      allow_any_instance_of(FyberRequest).to receive(:get_offers).and_return(
        [{ 
          title:  "Tap Fish",
          offer_id:  "13554",
          teaser:  "Download and START",
          required_actions: "Download and START",
          link: "http://iframe.sponsorpay.com/mbrowser?appid=157&lpid=11387&uid=player1",
          offer_types: [
            { 
              offer_type_id: "101", 
              readable: "Download" 
            }, 
            { 
              offer_type_id: "112", 
              readable: "Free" 
            } 
          ], 
          thumbnail: { 
            lowres: "http://cdn.sponsorpay.com/assets/1808/icon175x175-2_square_60.png",
            hires: "http://cdn.sponsorpay.com/assets/1808/icon175x175-2_square_175.png"
          },
          payout: "90",
          time_to_payout: {
            amount: "1800",
            readable: "30 minutes" 
          }
        }]
      )
      
      visit fyber_offers_path
      
      expect(page).to have_content 'Fyber Offers'
      within(".form-horizontal") do
        fill_in 'fyber_offer[uid]', :with => 'player1'
      end
      click_button 'Submit'
      expect(page).to have_content 'Results'
      expect(find('.title')).to have_content('Tap Fish')
      expect(find('.payout')).to have_content('90')
      expect(find('.thumbnail img')['src']).to have_content('http://cdn.sponsorpay.com/assets/1808/icon175x175-2_square_60.png')
    end
  end
end
