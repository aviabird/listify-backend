module Oauth
  class Instagram < Oauth::Base
    ACCESS_TOKEN_URL = 'https://api.instagram.com/oauth/access_token'
    DATA_URL         = 'https://api.instagram.com/v1/users/self'

    def get_full_name
      data['data']['full_name']
    end


    def get_data
      response = @client.get(DATA_URL, access_token: @access_token)
      @data = JSON.parse(response.body).with_indifferent_access
      @data['image_url'] = @data['data']['profile_picture'] if @data['data']['profile_picture'].present?
      @uid = @data[:data][:id]
      @data
     end


  end
end