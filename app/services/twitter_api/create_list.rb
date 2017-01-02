module TwitterApi
  class CreateList < TwitterApi::Base

    def call(list: nil, user: nil)
      @db_list = list
      @usernames =  @db_list.members.pluck(:screen_name)
      @user = user
      @result = { status: false }
      
      user_list = create_new_list_on_twitter
      add_members_to_list(user_list)
      new_list = save_list_to_database(user_list)
      @result[:new_user_list] = new_list
      @result[:status] = true
      return @result
    end

    def create_new_list_on_twitter
      list = @client.create_list(@db_list.name + "-" + rand(100).to_s)
      list
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
  end
end