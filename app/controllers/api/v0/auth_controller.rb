module Api::V0
  # Auth Controller for Authentication user and other operations
  # like signIn and signUp. 
  class AuthController < ApiController

    #================ Function to Render Data =======================
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

    #=================================================================

    # Currently Login and Signup are same 
    def sign_in
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

    # Yet to implement
    # Move signup logic in sign_in to this method.
    def sign_up

    end

    private
  
      def twitter_oauth
        @oauth ||= Oauth::Twitter.new(params)
      end
  end
end
