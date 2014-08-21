class FyberOffersController < ApplicationController
  # GET /fyber_offers
  def index
  end
  
  # GET/fyber_offers/search
  def search
    @request = FyberRequest.new(fyber_offer_params)
    @offers = @request.get_offers
    flash[:alert] = @request.message unless @offers.present?
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def fyber_offer_params
      params.require(:fyber_offer).permit(:uid, :pub0, :page)
    end
end
