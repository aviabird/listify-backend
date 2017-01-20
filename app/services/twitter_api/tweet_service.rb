module TwitterApi
  class TweetService < TwitterApi::Base
    def add_to_fav(tweet)
      begin
        user_list_id = tweet[:user_list_id]
        res = @client.favorite!([tweet])
        tweets = add_user_list_id_to_tweets(user_list_id, res)
        # Return fav tweet
        return { status: true, feed: tweets };
      rescue => e
        return { status: false, error: e }
      end
    end

    def remove_tweet_from_fav(tweet)
      begin
        user_list_id = tweet[:user_list_id]
        res = @client.unfavorite([tweet])
        tweets = add_user_list_id_to_tweets(user_list_id, res)
        # Return tweet
        return { status: true, feed: tweets };
      rescue => e
        return { status: false, error: e }
      end
    end

    def retweet(tweet)
      begin
        user_list_id = tweet[:user_list_id]
        res = @client.retweet([tweet])
        retweet_status = res.first.to_hash[:retweeted_status]
        retweeted_tweets = add_user_list_id_to_tweets(user_list_id, [retweet_status])
        # Return retweeted tweet
        return { status: true, feed: [retweeted_tweets] }
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


    private
    
      def add_user_list_id_to_tweets(user_list_id, tweets)
        tweets.map!{|tweet| tweet.to_hash.merge(user_list_id: userListId)}
        tweets
      end
  end
end