class FyberRequest
  require 'digest/sha1'
  include HTTParty
  
  attr_reader :appid, :pub0, :page, :uid, :device_id, :locale, :ip, 
    :offer_types, :ps_time, :timestamp, :os_version, :message

  base_uri 'api.sponsorpay.com/feed/v1'
  
  def initialize(args)
    @uid = args[:uid]
    @pub0 = args[:pub0]
    @page = args[:page]
    @ps_time = args[:ps_time]
    @os_version = args[:os_version]
    @device_id = args[:device_id] || '2b6f0cc904d137be2e1730235f5664094b831186'
    @locale = args[:locale] || 'de'
    @ip = args[:ip] || '109.235.143.113'
    @offer_types = args[:offer_types]
    @appid = args[:appid] || '157'
    @timestamp = args[:timestamp] || Time.now.to_i
  end
  
  def get_offers
    response = self.class.get('/offers.json', options)
    @message = response.parsed_response['message']
    if response_signature(response.body) == response.headers['x-sponsorpay-response-signature']
      return response.parsed_response[:offers]
    else
      @message = "Tampered response. Invalid Signature" if response.headers['x-sponsorpay-response-signature'].present?
      return nil
    end
  end
    
  def options
    {query: request_parameters.merge({hashkey: hashkey})}
  end
    
  def request_parameters
    params = {uid: @uid, appid: @appid, device_id: @device_id, locale: @locale,  timestamp: @timestamp}
    params[:offer_types] = @offer_types if @offer_types.present?
    params[:ip] = @ip if @ip.present?
    params[:os_version] = @os_version if @os_version.present?
    params[:pub0] = @pub0 if @pub0.present?
    params[:page] = @page if @page.present?
    params[:ps_time] = @ps_time if @ps_time.present?
    params
  end
    
  def hashkey
    request_params = request_parameters.keys.sort.map{|key| "#{key}=#{request_parameters[key]}"}.join('&')
    Digest::SHA1.hexdigest "#{request_params}&#{Rails.application.secrets.fyber_api_key}"
  end
  
  def response_signature(body)
    Digest::SHA1.hexdigest "#{body}#{Rails.application.secrets.fyber_api_key}"
  end
end
