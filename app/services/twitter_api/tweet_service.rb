module TwitterApi
  class TweetService < TwitterApi::Base
    def add_to_fav(tweet)
      begin
        user_list_id = tweet[:user_list_id]
        res = @client.favorite!([tweet.to_unsafe_h["id_str"]])
        tweets = add_user_list_id_to_tweets(user_list_id, res)
        # Return fav tweet
        return { status: true, feed: tweets }
      rescue => e
        return { status: false, error: e }
      end
    end

    def remove_tweet_from_fav(tweet)
      begin
        user_list_id = tweet[:user_list_id]
        res = @client.unfavorite([tweet.to_unsafe_h["id_str"]])
        tweets = add_user_list_id_to_tweets(user_list_id, res)
        # Return tweet
        return { status: true, feed: tweets }
      rescue => e
        return { status: false, error: e }
      end
    end

    def retweet(tweet)
      begin
        user_list_id = tweet[:user_list_id]
        res = @client.retweet([tweet.to_unsafe_h["id_str"]])
        retweet_status = res.first.to_hash[:retweeted_status]
        retweeted_tweets = add_user_list_id_to_tweets(user_list_id, [retweet_status])
        # Return retweeted tweet
        return { status: true, feed: [retweeted_tweets] }
      rescue => e
        return { status: false, error: e }
      end
    end


    def reply(tweet, msg)
      begin
        user_list_id = tweet[:user_list_id]
        tweet_id = tweet[:id_str]
        reply = @client.update(msg.to_s, in_reply_to_status_id: tweet_id)
        
        tweet_with_replies = merge_reply_with_tweet(tweet, reply)
        tweets = add_user_list_id_to_tweets(user_list_id, [tweet_with_replies])
        return { status: true, feed: tweets }
      rescue => e
        return {status: false, error: e}
      end
    end

    def test
      binding.pry
    end

    private
    
      def add_user_list_id_to_tweets(user_list_id, tweets)
        tweets.map!{|tweet| tweet.to_hash.merge(user_list_id: user_list_id)}
        tweets
      end

      def merge_reply_with_tweet(tweet, reply)
        replies = tweet[:replies]
        if(replies)
          replies.push(reply.to_hash)
          tweet[:replies] = replies
          tweet
        else
          newReplies = []
          newReplies.push(reply.to_hash)
          tweet[:replies] = newReplies
          tweet
        end
      end
  end
end