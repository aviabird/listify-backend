module TwitterApi
  class Base
    def initialize(params: nil)
      @client = Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV['TWITTER_KEY']
        config.consumer_secret     = ENV['TWITTER_SECRET']
        config.access_token        = params[:access_token]
        config.access_token_secret = params[:secret_token]
      end
    end
  end
end