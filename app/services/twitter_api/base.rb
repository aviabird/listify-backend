module TwitterApi
  class Base
    attr_accessor :client
    
    def initialize(params: nil)
      @client = Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV['TWITTER_KEY']
        config.consumer_secret     = ENV['TWITTER_SECRET']
        config.access_token        = params[:access_token]
        config.access_token_secret = params[:secret_token]
      end
    end

    def get_all_replies_for(tweet_id, screen_name)
      result = []
      
      response = @client.search("to:#{screen_name}", result_type: "recent", count: 10).to_hash
      
      replies = response[:statuses]

      replies.each do |tweet|
        if(tweet[:in_reply_to_status_id] == tweet_id)
          result.push(tweet)
        end
      end

      return result
    end
  end
end