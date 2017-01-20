module TwitterApi
  class AllListTimeline < TwitterApi::Base
    def call(user_lists)
      all_tweets = []
      user_lists.each do |user_list|
        twitter_list_id = user_list.twitter_list_id

        tweets = @client.list_timeline(twitter_list_id.to_i, { count: 1 })

        # tweets.map!{|tweet| tweet.to_hash.merge(user_list_id: user_list.id.to_s)}

        tweets.map! do |tweet|
          tweet = tweet.to_hash
          id = tweet[:id]
          user_screen_name = tweet[:user][:screen_name]

          replies = get_all_replies_for(id, user_screen_name)
          tweet[:replies] = replies

          tweet.merge(user_list_id: user_list.id.to_s)        
        end


        all_tweets.push(tweets)
      end
      return all_tweets.flatten!
    end  
  end
end