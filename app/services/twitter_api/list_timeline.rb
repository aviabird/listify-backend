module TwitterApi
  class ListTimeline < TwitterApi::Base
    
    def retrive_timeline(listId)
      tweets = @client.list_timeline(listId.to_i, { count: 1 })
      tweets
    end
  
  end
end