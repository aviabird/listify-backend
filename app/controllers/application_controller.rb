class ApplicationController < ActionController::API
  include ActionController::RequestForgeryProtection

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  before_action :set_current_user

  # Override Devise authenticate method 
  def authenticate_user!
    unauthorized! unless current_user
  end
  
  def unauthorized!
    head :unauthorized
  end

  private

  def set_current_user
    token = request.headers['Authorization'].to_s.split(' ').last
    # token = request.params[:token]
    return unless token

    payload = Token.new(token)

    @current_user = User.find(payload.user_id) if payload.valid?
  end
end
