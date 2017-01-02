module TwitterApi
  class ListTimeline < TwitterApi::Base
    
    def retrive_timeline(listId, userListId)
      tweets = @client.list_timeline(listId.to_i, { count: 1 })
      tweets.map!{|tweet| tweet.to_hash.merge(user_list_id: userListId)}
      tweets
    end
  
  end
end