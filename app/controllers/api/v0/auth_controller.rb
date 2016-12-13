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

  # Twitter don't support auth2 protocol yet, so it has it's own implementation for now
  def twitter
    if params[:oauth_token].blank?
      render_success({ oauth_token: twitter_oauth.request_token })
    else
      render_success({ token: twitter_oauth.access_token })
    end
  end

  def twitter_step_2
    if twitter_oauth.authorized?
      if User.from_auth(twitter_oauth.formatted_account_info, current_user)
        render_success("connected twitter to profile successfuly")
      else
        render_error "This twitter account is used already"
      end
    else
      render_error("There was an error with twitter. please try again.")
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
        @user = User.create_or_update(@oauth)
        @user && render_success({token: Token.encode(@user.id)})
      else
        render_error("There was an error with #{params['provider']}. please try again.")
      end
    end

    def create_new_user
      if params
        user_attributes = { email: params[:email],
                            access_token: params[:userAuth][:access_token],
                            secret_token: params[:userAuth][:secret_token]
                          } 
        @user = User.find_or_create(user_attributes)
        @user && render_success({token: Token.encode(@user.id)})
      else
        render_error("There was an error with #{params['provider']}. please try again.")
      end

    end

    private
  
      def twitter_oauth
        @oauth ||= Oauth::Twitter.new(params)
      end
  end
end
