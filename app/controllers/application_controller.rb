class ApplicationController < ActionController::API
  # include DeviseTokenAuth::Concerns::SetUserByToken

  # # Prevent CSRF attacks by raising an exception.
  # # For APIs, you may want to use :null_session instead.

  # protect_from_forgery with: :exception, if: Proc.new { |c| c.request.format != 'application/json' }
  # protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json'}

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include ActionController::RequestForgeryProtection

  protect_from_forgery with: :null_session
  before_action :set_current_user
  
  def authenticate_user!
    unauthorized! unless current_user
  end
  
  def unauthorized!
    head :unauthorized
  end

  private

  def set_current_user
    # token = request.headers['Authorization'].to_s.split(' ').last
    token = request.params[:token]
    return unless token

    payload = Token.new(token)

    @current_user = User.find(payload.user_id) if payload.valid?
  end

  # include DeviseTokenAuth::Concerns::SetUserByToken
  # include ActionController::Cookies

  # def authenticate_current_user
  #   head :unauthorized if get_current_user.nil?
  # end

  # def get_current_user
  #   return nil unless cookies[:auth_headers]
  #   auth_headers = JSON.parse cookies[:auth_headers]

  #   expiration_datetime = DateTime.strptime(auth_headers['expiry'], '%s')
  #   current_user = User.find_by(uid: auth_headers['uid'])

  #   if current_user &&
  #      current_user.tokens.has_key?(auth_headers['client']) &&
  #      expiration_datetime > DateTime.now

  #      @current_user = current_user
  #   end

  #   @current_user
  # end
end
