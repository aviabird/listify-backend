module TwitterApi
  class Base
    def initialize(params)
      @client = Twitter::REST::Client.new do |config|
        config.consumer_key        = "TSOSvmRILlXHXeci9WJPFwmEX"
        config.consumer_secret     = "5hoSZ6AkGnJ3u6UCicBnTK66lWkK36NYDa1Bm4LwAw4r1P0JBL"
        config.access_token        = params[:access_token]
        config.access_token_secret = params[:secret_token]
      end
      @twitter_account = TwitterOAuth::Client.new(
        consumer_key: "TSOSvmRILlXHXeci9WJPFwmEX", 
        consumer_secret: "5hoSZ6AkGnJ3u6UCicBnTK66lWkK36NYDa1Bm4LwAw4r1P0JBL",
        token: params[:access_token],    
        secret: params[:secret_token])
      
    end

  end
end