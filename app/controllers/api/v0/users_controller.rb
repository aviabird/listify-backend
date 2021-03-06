module Api::V0
  class UsersController < ApiController
    before_action :authenticate_user!

    def create_list
      list = List.includes(:members).find(params["id"])
      
      access_token = current_user.access_tokens["twitter"]
      secret_token =  current_user.secret_tokens["twitter"]

      service_params = { access_token: access_token, secret_token: secret_token }

      @twitter_create_list = TwitterApi::CreateList.new(params: service_params)
      result = @twitter_create_list.call(list: list, user: current_user)
      # result = { status: true, new_user_list: current_user.users_lists.first}
      render json: result
    end

    def list_timeline
      userList = current_user.users_lists.find(params[:index_id])
      twitter_list_id = userList.twitter_list_id
      access_token = current_user.access_tokens["twitter"]
      secret_token =  current_user.secret_tokens["twitter"]

      service_params = { access_token: access_token, secret_token: secret_token }
      @twitter_list_timeline = TwitterApi::ListTimeline.new(params: service_params)

      tweets = @twitter_list_timeline.retrive_timeline(twitter_list_id, userList.id.to_s)
      render json: tweets
    end


    def user_list
      user_list = current_user.users_lists.all
      render json: user_list
    end

    def user_detail
      access_token = current_user.access_tokens["twitter"]
      secret_token =  current_user.secret_tokens["twitter"]
      service_params = { access_token: access_token, secret_token: secret_token }
      @twitter_client = TwitterApi::RetriveUserDetail.new(params: service_params)
      result = @twitter_client.call
      render json: result
    end

    def all_feeds
      user_lists = current_user.users_lists.all

      access_token = current_user.access_tokens["twitter"]
      secret_token =  current_user.secret_tokens["twitter"]
      service_params = { access_token: access_token, secret_token: secret_token}
      @twitter_client = TwitterApi::AllListTimeline.new(params: service_params)
      tweets = @twitter_client.call(user_lists)
      render json: tweets 
    end


    def unfollow_list
      user_list_to_unfollow = current_user
                                .users_lists
                                .where(list_id: params["id"])
                                .first

      user_list_id = user_list_to_unfollow.as_json["id"]

      # Delete the user_list
      user_list_to_unfollow.delete


      # Return the list that is unfollowed to update the lists in store.
      unfollowed_list = List.find(params["id"])
                            .as_json
                            .merge(isFollowing: false)

      result = { status: true, unfollowed_list: unfollowed_list, user_list_id: user_list_id}
      render json: result
    end
  end
end
