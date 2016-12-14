module Api::V0
  class TweetsController <  ApiController
    before_action :authenticate_user!

    def user_info
      binding.pry
      params = { access_token: current_user.access_tokens[:twitter], 
                secret_token:  current_user.secret_tokens[:twitter] }
      @client = Twitter::REST::Client.new do |config|
        config.consumer_key        = "TSOSvmRILlXHXeci9WJPFwmEX"
        config.consumer_secret     = "5hoSZ6AkGnJ3u6UCicBnTK66lWkK36NYDa1Bm4LwAw4r1P0JBL"
        config.access_token        = params[:access_token]
        config.access_token_secret = params[:secret_token]
      end      
      tweeits = @client

    end
  end
end