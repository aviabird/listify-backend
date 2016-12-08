module Oauth
  class Base 
    attr_reader :provider, :data, :access_token, :uid
    
    # Initializes the Oauth 
    # providers
    # client
    # access_token
    def initialize(params)
      # This retrives the provider from the class name that has been called
      #  === Example
      #   Oauth::Facebook => facebook
      @provider = self.class.name.split('::').last.downcase
      @client = HTTPClient.new
      prepare_params(params)
      @access_token = params[:access_token].presence || get_access_token
    end

    def prepare_params(params)
      @params = {
        code:          params[:code],
        redirect_uri:  params[:redirectUri],
        client_id:     Rails.application.secrets["#{@provider.upcase}_KEY".to_sym],
        client_secret: Rails.application.secrets["#{@provider.upcase}_SECRET".to_sym],
        grant_type:    'authorization_code'
      }
    end
    
    def get_access_token
      response = @client.post(self.class::ACCESS_TOKEN_URL, @params)
      puts "ACCESS TOKEN RESPONSE - #{response.body}"
      JSON.parse(response.body)["access_token"]
    end

    def authorized?
      @access_token.present?
    end
  end
end
