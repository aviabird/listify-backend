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
        # Return tweet
        return { status: true, feed: res.first };
      rescue => e
        return { status: false, error: e }
      end
    end

    def retweet(tweet_id)
      begin
        # binding.pry
        res = @client.retweet([tweet_id])
        retweet_status = res.first.to_hash[:retweeted_status]
        # Return retweeted tweet
        return { status: true, feed: retweet_status }
      rescue => e
        return { status: false, error: e }
      end
    end



  end
end