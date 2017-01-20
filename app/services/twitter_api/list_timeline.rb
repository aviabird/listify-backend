module TwitterApi
  class ListTimeline < TwitterApi::Base
    
    def retrive_timeline(listId, userListId)
      tweets = @client.list_timeline(listId.to_i, { count: 1 })

      tweets.map! do |tweet|
      tweet = tweet.to_hash
       id = tweet[:id]
       user_screen_name = tweet[:user][:screen_name]

       replies = get_all_replies_for(id, user_screen_name)
       tweet[:replies] = replies

       tweet.merge(user_list_id: userListId)
     end

      tweets
    end  
  end
end