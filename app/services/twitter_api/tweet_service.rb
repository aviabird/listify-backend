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


    def reply(tweet_id, msg)
      begin
        response = @client.update(msg.to_s, in_reply_to_tweet_id: tweet_id)
        return { status: true, feed: response.to_hash }
      rescue => e
        return {status: false, error: e}
      end
    end
  end
end