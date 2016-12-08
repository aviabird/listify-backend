module Api::V0
  # Auth Controller for Authentication user and other operations
  # like signIn and signUp. 
  class AuthController < ApiController
    def render_data(data, status)
      render json: data, status: status, callback: params[:callback]
    end
    def render_error(message, status = :unprocessable_entity)
      render_data({ error: message }, status)
    end

    def render_success(data, status = :ok)
      if data.is_a? String
        render_data({ message: data }, status)
      else
        render_data(data, status)
      end
    end

    def authenticate
      # === Example
      #   params['provider'] = 'facebook'
      #   then "Oauth::#{params['provider'].titleize}".constantize => 
      #   Oauth::Facebook
      # 
      # TODO: send `provider` in params itself
      # 
      @oauth = "Oauth::#{params['provider'].titleize}".constantize.new(params)
      if @oauth.authorized?
        @user = User.for_oauth(@oauth)
        @user && render_success({token: Token.encode(@user.id)})
      else
        render_error("There was an error with #{params['provider']}. please try again.")
      end
    end
  end
end
