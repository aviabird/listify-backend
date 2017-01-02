module TwitterApi
  class AllListTimeline < TwitterApi::Base
    def call(user_lists)
      all_tweets = []
      user_lists.each do |user_list|
        twitter_list_id = user_list.twitter_list_id
        tweets = @client.list_timeline(twitter_list_id.to_i, { count: 2 })
        tweets.map!{|tweet| tweet.to_hash.merge(user_list_id: user_list.id.to_s)}
        all_tweets.push(tweets)
      end
      return all_tweets.flatten!
    end  
  end
end