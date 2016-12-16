module Api::V0
  class UsersController < ApiController
    before_action :authenticate_user!

    def create_list
      list = List.includes(:members).find(params["$oid"])
      
      access_token = current_user.access_tokens["twitter"]
      secret_token =  current_user.secret_tokens["twitter"]

      service_params = { access_token: access_token, secret_token: secret_token }

      @twitter_create_list = TwitterApi::CreateList.new(
                              params: service_params, 
                              list: list,
                              user: current_user)

      result = @twitter_create_list.call
      render json: result
    end
  end
end