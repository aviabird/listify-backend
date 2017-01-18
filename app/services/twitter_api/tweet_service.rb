module TwitterApi
  class TweetService < TwitterApi::Base
    def add_to_fav(tweet_id)
      begin
        res = @client.favorite!([tweet_id])
        # Return fav tweet
        return { status: true, feed: res.first };
      rescue => e
        return { status: false, error: e }
      end
    end

    def remove_tweet_from_fav(tweet_id)
      begin
        # binding.pry
        res = @client.unfavorite([tweet_id])
        # Return fav tweet
        return { status: true, feed: res.first };
      rescue => e
        return { status: false, error: e }
      end
    end

  end
end