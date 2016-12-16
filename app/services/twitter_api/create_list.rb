module TwitterApi
  class CreateList < TwitterApi::Base

    def initialize(params: nil, list: nil, user: nil)
      @client = Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV['TWITTER_KEY']
        config.consumer_secret     = ENV['TWITTER_SECRET']
        config.access_token        = params[:access_token]
        config.access_token_secret = params[:secret_token]
      end

      @db_list = list
      @usernames =  @db_list.members.pluck(:screen_name)
      @user = user
      @result = { status: false }
      return @result
    end


    def call
      user_list = create_new_list_on_twitter
      add_members_to_list(user_list)
      save_list_to_database(user_list)
      @result[:status] = true
      return @result
    end

    def create_new_list_on_twitter
      list = @client.create_list(@db_list.name)
      list
    end

    def add_members_to_list(user_list)
      @client.add_list_members(user_list, @usernames)
    end

    def save_list_to_database(user_list)
      list_attr = { user_id: @user.id, 
                    twitter_list_id: user_list.id, 
                    name: user_list.name,
                    slug: user_list.slug
                  }

      new_list = UsersList.new(list_attr)
      new_list.save
    end
  end
end