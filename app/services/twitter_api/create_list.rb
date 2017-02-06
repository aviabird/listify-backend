module TwitterApi
  class CreateList < TwitterApi::Base

    def call(list: nil, user: nil)
      @db_list = list
      @usernames =  @db_list.members.pluck(:screen_name)
      @user = user
      @result = { status: false }
      
      user_list = create_new_list_on_twitter
      
      add_members_to_list(user_list)
      
      new_user_list = save_list_to_database(user_list)

      all_user_lists = user.users_lists.all

      new_followed_unfollowed_list = followed_unfollowed_lists(all_user_lists)

      @result[:new_list] = new_followed_unfollowed_list.as_json
      @result[:new_user_list] = new_user_list
      @result[:status] = true
      return @result
    end

    def create_new_list_on_twitter
      list_name = (@db_list.name + "_" + rand(100).to_s).truncate(20)
      list = @client.create_list(list_name)
      return list
    end

    def add_members_to_list(user_list)
      @client.add_list_members(user_list, @usernames)
    end

    def save_list_to_database(user_list)
      list_attr = { user_id: @user.id,
                    list_id: @db_list.id,
                    twitter_list_id: user_list.id, 
                    name: user_list.name,
                    slug: user_list.slug
                  }
      new_list = UsersList.new(list_attr)
      new_list.save
      return new_list
    end

    def followed_unfollowed_lists(user_lists)
      followed_list_ids = user_lists.map {|ul| ul.list_id}

      followed_lists = List.find(followed_list_ids)
                          .as_json
                          .map {|li| li.merge(isFollowing: true)}
      
      not_followed_lists = List.not_in(_id: followed_list_ids)
                              .as_json
                              .map {|li| li.merge(isFollowing: false)}
      modified_lists = followed_lists + not_followed_lists
      return modified_lists
    end
  end
end